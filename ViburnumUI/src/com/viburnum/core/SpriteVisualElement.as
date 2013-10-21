package com.viburnum.core
{
	import com.viburnum.interfaces.IAsyValidatingClient;
	import com.alex.utils.NameUtil;
	import com.alex.utils.ObjectFactoryUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	use namespace viburnum_internal;

	/**
	 * SpriteVisualElement
	 * 
	 * <p>SimpleSpriteVisualElement实现了异步更新模型</p>
	 * 
	 * @author zhangcheng01
	 * 
	 */	
	
	public class SpriteVisualElement extends Sprite implements IAsyValidatingClient
	{
		protected var myAsyValidatingModel:IAsyValidatingClient;
		
		//同步初始化完成标志
		private var _snyInitialized:Boolean = false;
		//异步初始化完成标志
		private var _asyInitialized:Boolean = false;
		
		protected var _nestLevel:int = 0;
		
		viburnum_internal var isDebugMode:Boolean = false;
		
		public function SpriteVisualElement()
		{
			super();

			try
			{
				name = NameUtil.createUniqueName(this);
			}
			catch(error:Error)
			{
			}
			
			//if there is no Appilication eviroment, so defualt set it to a new one directly.
			myAsyValidatingModel =  ObjectFactoryUtil
				.createNewInstanceFromRegistedImplCls(IAsyValidatingClient, null, this) || new AsyValidatingClient(this);

			//ensure first to handle with
			this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler, false, int.MAX_VALUE);
		}
		
		public function get initialized():Boolean
		{
			return _snyInitialized;
		}
		
		public function get createCompleted():Boolean
		{
			return _asyInitialized;
		}
		
		/**
		 * @private 
		 * 
		 * 返回 异步更新对象的优先级。
		 * 
		 * <p>如果是显示对象的话则为层深</p> 
		 * 
		 */		
		public final function get nestLevel():int
		{
			return _nestLevel;
		}
		
		/**
		 * @private 
		 * 设置异步更新对象的优先级。
		 * 
		 * <p>如果显示对象还有IAsyValidatingClient的Child同时还要更新Child的nestLevel</p>
		 * 
		 */		
		public function set nestLevel(value:int):void
		{
			if(_nestLevel != value)
			{
				_nestLevel = value;
				
				if(_asyInitialized)
				{
					for(var i:int = 0, n:int = numChildren; i < n; i++)
					{
						var child:DisplayObject = getChildAt(i);
						
						if(child is IAsyValidatingClient)
						{
							IAsyValidatingClient(child).nestLevel = _nestLevel + 1;
						}
					}
				}
			}
		}
		
		/**
		 * 标记组件，以便在稍后屏幕更新期间调用该组件的 commitProperties() 方法.  
		 * 
		 * <p>Invalidation 是一个很有用的机制，可将组件更改延迟到稍后屏幕更新时进行处理，从而消除了重复的工作。
		 * 例如，要更改文本颜色和大小，如果在更改颜色后立即进行更新，然后在设置大小后再更新大小，就有些浪费。
		 * 同时更改两个属性后再使用新的大小和颜色一次性呈现文本，效率会更高。</p>
		 * 
		 * <p>很少调用 Invalidation 方法。通常，在组件上设置属性会自动调用合适的 invalidation 方法。</p>
		 * 
		 */	
		public function invalidateProperties():void
		{
			if(!_snyInitialized) return;
			
			if(isDebugMode) trace(this, "invalidateProperties ", nestLevel);
			
			myAsyValidatingModel.invalidateProperties();
		}
		
		/**
		 * 更新组建属性.
		 * 
		 * <p>该功能是ISystemStage中的IRequestDriveAsynUpdater完成的。</p>
		 * 
		 * @see com.viburnum.core.IRequestDriveAsynUpdater 
		 * 
		 */	
		public function validateProperties():void
		{
			if(isDebugMode) trace(this, "validateProperties ", nestLevel);
			
			onValidateProperties();
		}
		
		/**
		 * 标记组件，以便在稍后屏幕更新期间调用该组件的 measure() 方法.
		 */
		public function invalidateSize():void
		{
			if(!_snyInitialized) return;
			
			if(isDebugMode) trace(this, "invalidateSize ", nestLevel);
			
			myAsyValidatingModel.invalidateSize();
		}
		
		/**
		 *	更新组建尺寸.
		 * 
		 * <p>该功能是ISystemStage中的IRequestDriveAsynUpdater完成的。</p>
		 * 
		 *  @see com.viburnum.core.IRequestDriveAsynUpdater 
		 * 
		 */	
		public function validateSize():void 
		{
			if(isDebugMode) trace(this, "validateSize ", nestLevel);
			
			onValidateSize();
		}
		
		/**
		 * 标记组件，以便在稍后屏幕更新期间调用该组件的 validateDisplayList() 方法.  
		 */		
		public function invalidateDisplayList():void 
		{
			if(!_snyInitialized) return;
			
			if(isDebugMode) trace(this, "invalidateDisplayList ", nestLevel);
			
			myAsyValidatingModel.invalidateDisplayList();
		}
		
		/**
		 * 更新显示列表.
		 * 
		 * <p>这里的逻辑一般是绘制、布局 等, 该功能是ISystemStage中的IRequestDriveAsynUpdater完成的。
		 * 该函数会调用updateDisplayList</p>
		 * 
		 * @see com.viburnum.core.IRequestDriveAsynUpdater
		 */				
		public function validateDisplayList():void
		{
			if(isDebugMode) trace(this, "validateDisplayList ", nestLevel);
			
			onValidateDisplayList();

			if(!_asyInitialized)
			{
				_asyInitialized = true;
				
				onCreateComplete();
			}
		}
		
		/**
		 * 同步更新所有操作.
		 * 
		 *  <p>该功能是ISystemStage中的IRequestDriveAsynUpdater完成的。</p>
		 * 
		 *  @see com.viburnum.core.IRequestDriveAsynUpdater
		 * 
		 */		
		public function validateNow(skipNestLevel:Boolean = false):void 
		{
			myAsyValidatingModel.validateNow(skipNestLevel);
		}

		/**
		 * 组件被添加到显示列表回调该函数.
		 */		
		protected function onAttachToDisplayList():void 
		{
			if(parent is IAsyValidatingClient)
			{
				nestLevel = IAsyValidatingClient(parent).nestLevel + 1;
			}
		}
		
		protected function onPreInitialize():void {};
		
		protected function onInitialize():void {};
		
		/**
		 * @private
		 * 
		 * 第一次初始化时提交异步同步请求,高级方法慎用
		 * 
		 */	
		viburnum_internal function onInitializeInvalidate():void { invalidateDisplayList(); }
		
		/**
		 * 初始化完毕. 
		 * 
		 * <p>组件在完成第一的完全异步更新后会调用该函数。</p>
		 * 
		 */	
		protected function onInitializeComplete():void {};
		
		/**
		 * 处理对组件设置的属性.
		 * 
		 */	
		protected function onValidateProperties():void {};
		
		/**
		 * @private 
		 */		
		protected function onValidateSize():void {};
		
		/**
		 * @private 
		 */	
		protected function onValidateDisplayList():void {};
		
		/**
		 * 组件创建完毕. 
		 * 
		 * <p>组件在完成第一的完全异步更新后会调用该函数。</p>
		 * 
		 */	
		protected function onCreateComplete():void {};

		/**
		 * 组件被从显示列表中移除会回调该函数.
		 */		
		protected function onDetachFromDisplayList():void {};
		
		//event Handler========================================================
		//flash player has add to stage fire twice bug. somtimes, remenber that.
		private function addToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler, false);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler, false, int.MAX_VALUE);

			//trace("addToStageHandler", event.target);
			onAttachToDisplayList();
			
			if(!_snyInitialized)
			{
				onPreInitialize();
				onInitialize();
				_snyInitialized = true;
				onInitializeInvalidate();//need to wait _snyInitialized set to true then it's works.
				onInitializeComplete();
			}
		}
		
		private function removeFromStageHandler(event:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler, false);
			this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler, false, int.MAX_VALUE);
			
			onDetachFromDisplayList();
		}
	}
}