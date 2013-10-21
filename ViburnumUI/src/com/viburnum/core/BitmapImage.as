package com.viburnum.core
{
    import com.alex.utils.IFactory;
    import com.viburnum.utils.LayoutUtil;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.geom.Matrix;
    import flash.utils.getDefinitionByName;

	/**
	 * BitmapImage是个轻量级的位图展示类.
	 * 
	 * <p>BitmapImage可以设置填充方式。</p>
	 * 
	 * <p>在皮肤中也会用到该类。BitmapImage中的source可以设置多种对象，Class(BitmapData, Bitmap, Displayobject) BitmapData Bitmap IFactory</p>
	 * 
	 * @see com.viburnum.components.BitmapFillMode
	 * 
	 * @author zhangcheng01
	 * 
	 */	
    public class BitmapImage extends LayoutSpriteElement
    {
		//不能同时存在
        private var _contentBitmapData:BitmapData = null;
		private var _contentDisplayObject:DisplayObject = null;

        private var _source:Object = null;//Class(BitmapData, Bitmap, Displayobject) BitmapData Bitmap IFactory
        private var _sourceChangedFlag:Boolean = false;
        
		private var _smoothBitmapContent:Boolean = false;
		private var _fillMode:String = BitmapFillMode.CLIP;

		/**
		 * 构造函数. 
		 */		
        public function BitmapImage()
        {
            super();
        }
		
		/**
		 * 获取显示对象源.
		 * 
		 * @param value 可能的类型有: Class(BitmapData, Bitmap, Displayobject), BitmapData Bitmap IFactory
		 * 
		 */	
        public function get source():Object
        {
            return _source;
        }
		
		/**
		 * 设置显示对象源.
		 * 
		 * <p>source 可能的类型有: Class(BitmapData, Bitmap, Displayobject) String, BitmapData Bitmap IFactory</p> 
		 * @param value
		 * 
		 */	
		[Inspectable(type="String")]
		public function set source(value:Object):void
		{
			if(_source != value)
			{
				_source = value;
				_sourceChangedFlag = true;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		/**
		 * @return 显示对象是否平滑处理.
		 * 
		 * <p>只针对实际显示对象为位图。</p>
		 */		
		public function get smoothBitmapContent():Boolean
		{
			return _smoothBitmapContent;
		}
		
		/**
		 * 设置显示对象是否平滑处理.
		 * 
		 * <p>只针对实际显示对象为位图生效。</p>
		 */	
		[Inspectable(type="Boolean")]
		public function set smoothBitmapContent(value:Boolean):void
		{
			if(_smoothBitmapContent != value)
			{
				_smoothBitmapContent = value;

				invalidateDisplayList();
			}
		}
		
		/**
		 * 获取显示对象的填充模式.
		 * 
		 * <p>只针对实际显示对象为位图生效。</p>
		 * 
		 * @see com.viburnum.components.BitmapFillMode
		 * 
		 * @return BitmapFillMode.CLIP || BitmapFillMode.SCALE || BitmapFillMode.REPEAT;
		 * @default BitmapFillMode.CLIP
		 * 
		 */		
		public function get fillMode():String
		{
			return _fillMode;
		}
		
		/**
		 * 设置显示对象的填充模式.
		 * 
		 * <p>只针对实际显示对象为位图生效。</p>
		 * 
		 * @see com.viburnum.components.BitmapFillMode
		 * 
		 * @return BitmapFillMode.CLIP || BitmapFillMode.SCALE || BitmapFillMode.REPEAT;
		 * @default BitmapFillMode.CLIP
		 * 
		 */	
		[Inspectable(defaultValue="clip", enumeration="clip, scale, repeat")]
		public function set fillMode(value:String):void
		{
			if(_fillMode != value)
			{
				_fillMode = value;
				
				invalidateDisplayList();
			}
		}
		
		/**
		 * @private 
		 */		
        override protected function onValidateProperties():void
        {
            super.onValidateProperties();

            if(_sourceChangedFlag)
            {
				_sourceChangedFlag = false;
				
				//destory before
				destoryDisplayContent();
				//create new by source
				createNewDisplayContentBySource(_source);
            }
        }
		
		private function destoryDisplayContent():void
		{
			if(_contentBitmapData != null)
			{
				_contentBitmapData.dispose();
				_contentBitmapData = null;
			}
			
			if(_contentDisplayObject != null)
			{
				if(_contentDisplayObject is MovieClip)
				{
					MovieClip(_contentDisplayObject).stop();
				}
				
				removeChild(_contentDisplayObject);
				_contentDisplayObject = null;
			}
		}
		
		private function createNewDisplayContentBySource(source:Object):void
		{
			if(source == null) return;
			
			if(source is String)
			{
				try
				{
					var cls:Class = getDefinitionByName(String(_source)) as Class;
//					trace("createNewDisplayContentBySource", cls);
					if(cls != null)
					{
						source = cls;
					}
				}
				catch(error:Error) 
				{
					source = null;
				};
			}
			
			if(source is IFactory || source is Class)
			{
				var contentInstance:* = source is IFactory ? 
					IFactory(source).newInstance() : 
					new source();
				
				createNewDisplayContentBySource(contentInstance);
				return;
			}
			
			if(source is Bitmap)
			{
				_contentBitmapData = Bitmap(source).bitmapData;
			}
			else if(source is BitmapData)
			{
				_contentBitmapData = BitmapData(source);
			}
			else if(source is DisplayObject)
			{
				_contentDisplayObject = DisplayObject(source);
				addChild(_contentDisplayObject);
			}
		}
		
		/**
		 * @private  
		 */		
        override protected function measure():void
        {
			var measuredW:Number = 0;
			var measuredH:Number = 0;
			
			if(_contentBitmapData != null)
			{
				if(_contentBitmapData != null)
				{
					measuredW = _contentBitmapData.width;
					measuredH = _contentBitmapData.height;
					
//					trace("measure", measuredW, measuredH);
				}
				else if(_contentDisplayObject != null)
				{
					measuredW = LayoutUtil.getDisplayObjectMeasuredWidth(_contentDisplayObject);
					measuredH = LayoutUtil.getDisplayObjectMeasuredHeight(_contentDisplayObject);
				}
			}
			
//			trace("measure2", measuredW, measuredH);

			setMeasuredSize(measuredW, measuredH);
        }

		/**
		 * @private 
		 * @param layoutWidth
		 * @param layoutHeight
		 * 
		 */		
        override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
        {
            super.updateDisplayList(layoutWidth, layoutHeight);
			graphics.clear();
			
			if(_contentBitmapData != null)
			{
				var matrix:Matrix = null;
				var reapet:Boolean = false;
				
				var contentWidth:Number = _contentBitmapData.width;
				var contentHeight:Number = _contentBitmapData.height;
				
				var drawWidth:Number = layoutWidth;
				var drawHeight:Number = layoutHeight;
				
				if(_fillMode == BitmapFillMode.SCALE)
				{
					matrix = new Matrix(layoutWidth / contentWidth, 0, 0, layoutHeight / contentHeight);
				}
				else if(_fillMode == BitmapFillMode.REPEAT)
				{
					reapet = true;
				}
				else//clip default
				{
					drawWidth = Math.min(contentWidth, layoutWidth);
					drawHeight = Math.min(contentHeight, layoutHeight);
				}
				
				graphics.beginBitmapFill(_contentBitmapData, 
					matrix, 
					reapet, 
					_smoothBitmapContent);
				
				graphics.drawRect(0, 0, drawWidth, drawHeight);
				
			}
			else if(_contentDisplayObject != null)
			{
				LayoutUtil.setDisplayObjectLayout2(_contentDisplayObject, 
					0, 0, 0, 0, layoutWidth, layoutHeight);
			}
			
			graphics.endFill();
        }
    }
}