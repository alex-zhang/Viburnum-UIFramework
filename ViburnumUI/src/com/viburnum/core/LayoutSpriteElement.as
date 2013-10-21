package com.viburnum.core
{
	import com.viburnum.interfaces.IAsyValidatingClient;
	import com.viburnum.interfaces.ILayoutElement;
	
	import flash.display.DisplayObjectContainer;
	
	use namespace viburnum_internal;
	
	/**
	 * <p>LayoutSpriteElement对象尺寸模型</p>
	 * 
	 * <p>LayoutSpriteElement(ILayoutElement)中所有的尺寸(除了width,height),其他都是
	 * 参考尺寸，最终组件呈现尺寸是父容器的布局策略决定的。</p>
	 * 
	 * <pre>一般是布局策略是:
	 * <ul>
	 * 	<li>1.precentSize</li>
	 *  <li>2.explicitSize</li>
	 *  <li>3.measuredSize</li>
	 * </ul>
	 * 
	 * 对象是否约束尺寸要看父容器的具体布局策略
	 * </pre>
	 * 
	 * @author zhangcheng01
	 * 
	 */	
	public class LayoutSpriteElement extends SpriteVisualElement implements ILayoutElement
	{
		viburnum_internal var explicitCanSkipMeasure:Boolean = false;
		
		private var _owner:DisplayObjectContainer;
		
		//当前实际尺寸
		private var _width:Number = 0;
		private var _height:Number = 0;
		
		//当前度量实际尺寸
		private var _measuredWidth:Number = 0;
		private var _measuredHeight:Number = 0;
		
		//显示指定的具体尺寸1, 2(百分比)
		private var _explicitWidth:Number = NaN;
		private var _explicitHeight:Number = NaN;
		private var _percentWidth:Number = NaN;
		private var _percentHeight:Number = NaN;
		
		//自身度量的约束尺寸值
		private var _measuredMinWidth:Number = 0;
		private var _measuredMinHeight:Number = 0;
		private var _measuredMaxWidth:Number = Number.MAX_VALUE;
		private var _measuredMaxHeight:Number = Number.MAX_VALUE;

		//显示指定的约束尺寸值
		private var _explicitMinWidth:Number = NaN;
		private var _explicitMinHeight:Number = NaN;
		private var _explicitMaxWidth:Number = NaN;
		private var _explicitMaxHeight:Number = NaN;
		
		private var _includeInLayout:Boolean = true;
		
		public function LayoutSpriteElement()
		{
			super();
				
			focusRect = false;//do our focus
			tabEnabled = false;
			tabChildren = false;
		}
		
		/**
		 * @private 
		 */
		public function get owner():DisplayObjectContainer
		{
			return _owner;
		}
		
		/**
		 * @private 
		 */
		public function set owner(value:DisplayObjectContainer):void
		{
			_owner = value;
		}
		
		//ILayoutElement Interface==========================================
		/**
		 * @private 
		 */		
		override public function set x(value:Number):void
		{
			move(value, this.y);
		}
		
		/**
		 * @private 
		 */		
		override public function set y(value:Number):void
		{
			move(this.x, value);
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		/**
		 * @private 
		 */		
		override public function set width(value:Number):void
		{
			if(isNaN(value) || value < 0) return;
			
			if(_width != value)
			{
				_explicitWidth = value;
				_percentWidth = NaN;

				//当用户显示设置宽度的时候将跳过自身的布局阶段
				_measuredWidth = value;
				
				//更新本身的显示
				setSize(value, _height);
				
				invalidateParentSizeAndDisplayList();
			}
		}

		override public function get height():Number
		{
			return _height;
		}
		
		/**
		 * @private 
		 */
		override public function set height(value:Number):void
		{
			if(isNaN(value) || value < 0) return;
			
			if(_height != value)
			{
				_explicitHeight = value;
				_percentHeight = NaN;
				
				//当用户显示设置宽度的时候将跳过自身的布局阶段
				_measuredWidth = value;

				setSize(_width, value);
				
				invalidateParentSizeAndDisplayList();
			}
		}
		
		/**
		 * 返回组件的最小宽度。 
		 */		
		public function get minWidth():Number
		{
			return isNaN(_explicitMinWidth) ? _measuredMinWidth : _explicitMinWidth;
		}

		/**
		 * 显示设置组件的最小宽度.
		 * 
		 * <p>默认是由组件的度量阶段完成。</p>  
		 * 
		 */		
		[Inspectable(type="Number")]
		public function set minWidth(value:Number):void
		{
			if(_explicitMinWidth != value)
			{
				_explicitMinWidth = value;

				//本身不负责自身大小尺寸的约束完全由父容器实现
				invalidateParentSizeAndDisplayList();
			}
		}
		
		/**
		 * 返回组件最小高度.
		 */		
		public function get minHeight():Number
		{
			return isNaN(_explicitMinHeight) ? _measuredMinHeight : _explicitMinHeight;
		}
		
		/**
		 * 显示设置组件的最小高度.
		 * 
		 * <p>默认是由组件的度量阶段完成。</p>  
		 * 
		 */
		[Inspectable(type="Number")]
		public function set minHeight(value:Number):void
		{
			if(_explicitMinHeight != value)
			{
				_explicitMinHeight = value;
				
				//本身不负责自身大小尺寸的约束完全由父容器实现
				invalidateParentSizeAndDisplayList();
			}
		}
		
		/**
		 * 返回组件的最大高度.
		 */		
		public function get maxWidth():Number
		{
			return isNaN(_explicitMaxWidth) ? _measuredMaxWidth : _explicitMaxWidth;
		}
		
		/**
		 * 显示设置组件最大宽度. 
		 * 
		 * <p>默认是由组件的度量阶段完成</p> 
		 */
		[Inspectable(type="Number")]
		public function set maxWidth(value:Number):void
		{
			if(_explicitMaxWidth != value)
			{
				_explicitMaxWidth = value;
				//本身不负责自身大小尺寸的约束完全由父容器实现
				invalidateParentSizeAndDisplayList();
			}
		}
		
		/**
		 * 返回组件的最大高度.
		 * 
		 * <p>默认是由组件的度量阶段完成</p> 
		 * 
		 */		
		public function get maxHeight():Number
		{
			return isNaN(_explicitMaxHeight) ? _measuredMaxHeight : _explicitMaxHeight;
		}
		
		/**
		 * 显示设置组件最大高度.
		 * 
		 * <p>默认是由组件的度量阶段完成</p> 
		 */	
		[Inspectable(type="Number")]
		public function set maxHeight(value:Number):void
		{
			if(_explicitMaxHeight != value)
			{
				_explicitMaxHeight = value;
				//本身不负责自身大小尺寸的约束完全由父容器实现
				invalidateParentSizeAndDisplayList();
			}
		}
		
		/**
		 * 返回组件的显示宽度.
		 */		
		public function get explicitWidth():Number
		{
			return _explicitWidth;
		}
		
		/**
		 * 返回组件显示高度.
		 */
		public function get explicitHeight():Number
		{
			return _explicitHeight;
		}
		
		/**
		 * 返回组件的百分比宽度. 
		 */		
		public function get percentWidth():Number
		{
			return _percentWidth;
		}

		/**
		 * 设置组件的百分比宽度，会导致父容器重新度量和布局.
		 */
		public function set percentWidth(value:Number):void
		{
			if(isNaN(value) || value < 0) return;
			
			if(_percentWidth != value)
			{
				_percentWidth = value;
				_explicitWidth = NaN;
				
				invalidateSize();
			}
		}

		/**
		 * 返回组件的百分比高度. 
		 */		
		public function get percentHeight():Number
		{
			return _percentHeight;
		}
		
		/**
		 * 设置组件的百分比高度，会导致父容器重新度量和布局.
		 */	
		public function set percentHeight(value:Number):void
		{
			//不允许显示设置百分比为非数字
			if(isNaN(value) || value < 0) return;
			
			if(_percentHeight != value)
			{
				_percentHeight = value;
				_explicitHeight = NaN;
				
				invalidateSize();

				invalidateParentSizeAndDisplayList();
			}
		}

		/**
		 * 返回组件的度量宽度.
		 * 
		 * <p>如果explicitWidth不为NaN则该值即为explicitWidth否则为measuredWidth,
		 * 这里和flex中略有不同</p> 
		 */		
		public function get measuredWidth():Number
		{
			return isNaN(_explicitWidth) ? _measuredWidth : _explicitWidth;
		}

		/**
		 * 返回组件的度量宽度.
		 * 
		 * <p>如果explicitHeight不为NaN则该值即为explicitHeight否则为measuredHeight,
		 * 这里和flex中略有不同</p> 
		 */	
		public function get measuredHeight():Number
		{
			return isNaN(_explicitHeight) ? _measuredHeight : _explicitHeight;
		}

		/**
		 * @return 是否参与父容器布局.
		 */		
		public function get includeInLayout():Boolean
		{
			return _includeInLayout;
		}

		/**
		 * 设置是否参与父容器布局.
		 * 
		 *	@default true 
		 * 
		 */
		[Inspectable(type="Boolean")]
		public function set includeInLayout(value:Boolean):void
		{
			if(_includeInLayout != value)
			{
				_includeInLayout = value;
				
				//父容器重新布局所有child
				invalidateParentSizeAndDisplayList();
			}
		}

		/**
		 * 将组件移动到其父项内的指定位置。调用此方法的效果与设置组件的 x 和 y 属性完全相同.
		 */		
		public function move(newX:Number, newY:Number):void
		{
			if(super.x != newX) super.x = newX;
			if(super.y != newY) super.y = newY;
		}

		/**
		 * 调整对象大小.
		 * 
		 * <p>调用 setSize() 方法并不设置 explictWidth 和 explicitHeight 属性，
		 * 因此，将来进行布局计算时可能会导致对象还原为先前的大小。这一点与直接设置 width 和 height 属性不同。</p>
		 * 
		 * 这里的设置不会导致父容器布局.
		 * 
		 */
		public function setSize(newWidth:Number, newHeight:Number):void
		{
			var sizeChanged:Boolean = false;
			if(!isNaN(newWidth) && newWidth > 0)
			{
				if(_width != newWidth)
				{
					_width = newWidth;
					sizeChanged = true;
				}
			}

			if(!isNaN(newHeight) && newHeight > 0)
			{
				if(_height != newHeight)
				{
					_height = newHeight;
					sizeChanged = true;
				}
			}

			if(sizeChanged)
			{
				invalidateDisplayList();
			}
		}
		
		/**
		 * 此对象影响其布局时（includeInLayout 为 true），使父项大小和显示列表失效的 Helper 方法。 
		 */		
		public final function invalidateParentSizeAndDisplayList():void
		{
			if(!_includeInLayout) return;
			
			if(parent is IAsyValidatingClient)
			{
				IAsyValidatingClient(parent).invalidateSize();
				IAsyValidatingClient(parent).invalidateDisplayList();
			}
		}
		
		/**
		 * 设置最小度量尺寸.
		 * 
		 * <p>在explicitMinWidth(explicitMinHeight)不为NaN时newMeasuredMinWidth(newMeasuredMinHeight)的设置时无效的。</p> 
		 * 
		 */		
		public final function setMeasuredMinSize(newMeasuredMinWidth:Number, newMeasuredMinHeight:Number):void
		{
			if(isNaN(_explicitMinWidth)) _measuredMinWidth = newMeasuredMinWidth;
			if(isNaN(_explicitMinHeight)) _measuredMinHeight = newMeasuredMinHeight;
		}
		
		/**
		 * 设置最大度量尺寸.
		 * 
		 * <p>在explicitMaxWidth(explicitMaxHeight)不为NaN时newMeasuredMaxWidth(newMeasuredMaxHeight)的设置时无效的。</p> 
		 * 
		 */	
		public final function setMeasuredMaxSize(newMeasuredMaxWidth:Number, newMeasuredMaxHeight:Number):void
		{
			if(isNaN(_explicitMaxWidth)) _measuredMaxWidth = newMeasuredMaxWidth;
			if(isNaN(_explicitMaxHeight)) _measuredMaxHeight = newMeasuredMaxHeight;	
		}
		
		/**
		 * 设置最大度量尺寸.
		 * 
		 * <p>在explicitWidth(explicitHeight)不为NaN时newMeasuredWidth(newMeasuredHeight)的设置时无效的。</p> 
		 * 
		 */	
		public final function setMeasuredSize(newMeasuredWidth:Number, newMeasuredHeight:Number):void
		{
			if(isNaN(_explicitWidth)) _measuredWidth = newMeasuredWidth;
			if(isNaN(_explicitHeight)) _measuredHeight = newMeasuredHeight;	
		}
		
		//Template Method
		/**
		 * @private 
		 * 
		 */		
		override protected function onValidateSize():void
		{
			super.onValidateSize();
			
			if(createCompleted)//已经完成本身的一次初始化
			{
				if(!canSkipMeasurement())
				{
					if(_includeInLayout)
					{
						//explicit2measured
						var preMinWidth:Number = this.minWidth;
						var preMinHeight:Number = this.minHeight;
						var preMaxWidth:Number = this.maxWidth;
						var preMaxHeight:Number = this.maxWidth;
						var preMeasuredWidth:Number = this.measuredWidth;
						var preMeasuredHeight:Number = this.measuredHeight;
					}
					
					measure();
					
					if(isDebugMode) trace(this, "measure", measuredWidth, measuredHeight, nestLevel);
					
					if(_includeInLayout)
					{
						//measuredSizeChanged
						if(preMinWidth != this.minWidth ||
							preMinHeight != this.minHeight ||
							preMaxWidth != this.maxWidth ||
							preMaxHeight != this.maxWidth ||
							preMeasuredWidth != this.measuredWidth ||
							preMeasuredHeight != this.measuredHeight)
						{
							//在组建度量完成后发现度量已经变化了之后的逻辑，这里是通知父容器重新度量和布局.
							invalidateParentSizeAndDisplayList();
						}
					}
				}
			}
			else//组件第一次初始化时的度量
			{
				if(!canSkipMeasurement())
				{
					measure();
					
					_width = this.measuredWidth;
					_height = this.measuredHeight;
					
					if(isDebugMode) trace(this, "measure", measuredWidth, measuredHeight);
				}
			}
		}
		
		//对象对本身的度量,最小尺寸,最大尺寸的度量
		/**
		 * 计算组件的默认大小和（可选）默认最小大小值.
		 * 
		 * <p>此方法是一种高级方法，可在创建子类时覆盖。您无需直接调用此方法，组件被添加到显示列表时，
		 * 以及调用组件的 invalidateSize() 方法时，框架将调用 measure() 方法</p>
		 * 
		 * <p>当设置组件的特定高度和宽度时，框架不会调用 measure() 方法，即使您显式调用 invalidateSize() 方法也不例外。
		 * 也就是说，仅当组件的 explicitWidth 属性或 explicitHeight 属性设置为 NaN 时，框架 才调用 measure() 方法。</p>
		 * 
		 * <p>覆盖此方法时，必须设置 measuredWidth 和 measuredHeight 属性以定义默认大小。
		 * 您可以选择设置 measuredMinWidth 和 measuredMinHeight 属性来定义默认的最小大小。
		 * 你可以通过setMeasuredSize(),setMeasuredMinSize(), setMeasuredMaxSize()来设置</p>
		 * 
		 * <p>但是explicitWidth(explicitHeight)不为NaN时对应的measuredWidth(measuredHeight)的设置时无效的,
		 * 同理explicitMaxWidht(explicitMaxHeight), explicitMinWidht(explicitMinHeight)对应的度量也是无效的</p>
		 * 
		 */		
		protected function measure():void
		{
		}
		
		override protected function onValidateDisplayList():void
		{
			super.onValidateDisplayList();
			
			updateDisplayList(_width, _height);
			
			if(isDebugMode) trace(this, "updateDisplayList", width, height);
		}
		
		/**
		 * 更新显示列表.
		 * 
		 * <p>这里主要完成屏幕的重绘和布局。该函数功能和flex中一致。</p>
		 *  
		 * @param layoutWidth
		 * @param layoutHeight
		 * 
		 */		
		protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			if(isDebugMode)
			{
				graphics.clear();
				graphics.beginFill(0xFF0000, 0.3);
				graphics.drawRect(0, 0, layoutWidth, layoutHeight);
				graphics.endFill();
				graphics.clear();
				graphics.lineStyle(5, 0xFFFF00);
				graphics.drawRect(0, 0, layoutWidth, layoutHeight);
				graphics.endFill();
			}
		}
		
		/**
		 * @private
		 * 
		 * 是否可以跳过对组建本身的度量.
		 * 
		 * <p>注意:组建第一次初始化时的度量是不可以跳过的。</p> 
		 * 
		 * 高级方法慎用
		 * 
		 */		
		viburnum_internal function canSkipMeasurement():Boolean
		{
			if(explicitCanSkipMeasure) return true;
			
			if(!isNaN(_explicitWidth) && !isNaN(_explicitHeight)) return true;
			
			return false;
		}
		
		/**
		 * @private
		 * 
		 * 第一次初始化时提交异步同步请求,高级方法慎用
		 * 
		 */	
		override viburnum_internal function onInitializeInvalidate():void
		{
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
	}
}