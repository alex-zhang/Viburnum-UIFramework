package com.viburnum.core
{
    import com.viburnum.core.plugins.DragOnFly;
    import com.viburnum.core.plugins.InteractionMonitor;
    import com.viburnum.core.plugins.MouseCursorDecorator;
    import com.viburnum.events.ViburnumEvent;
    import com.viburnum.interfaces.IDragOnFly;
    import com.viburnum.interfaces.IInteractionMonitor;
    import com.viburnum.interfaces.IMouseCursorDecorator;
    import com.viburnum.interfaces.IPluginComponent;
    import com.viburnum.interfaces.IPluginEntity;
    import com.viburnum.interfaces.IRequestDriveAsynUpdater;
    import com.viburnum.interfaces.IVirburnumDisplayObject;
    import com.alex.utils.ObjectFactoryUtil;
    
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import com.alex.utils.ClassFactory;
    import com.viburnum.managers.ILayerChildrenManager;
    import com.viburnum.managers.LayerChildrenManager;
    
	/**
	 * <code>SystemStage</code>可以单独使用也可以作为Applciaidion的BootStrap使用.
	 * 
	 * @author zhangCheng01
	 * 
	 */	
	
    public class SystemStage extends Sprite implements 
		IVirburnumDisplayObject, IPluginEntity, ILayerChildrenManager
    {
		public static const MOUSE_CURSOR_DECORATOR_NAME:String = "MouseCursorDecorator";
		public static const DRAG_ON_FLY_NAME:String = "DragOnFly";
		public static const INTERACTION_MONITOR_NAME:String = "InteractionMonitor";
		
		public var parameters:Object;
		
		protected var myPluginEntityImpl:PluginEntity;
		protected var myRequestDriveAsynUpdater:IRequestDriveAsynUpdater;
		protected var myLayerChildrenManager:ILayerChildrenManager;
		
		protected var myWidth:Number = 0;
		protected var myHeight:Number = 0;

		private var _initialized:Boolean = false;
		
        public function SystemStage()
        {
			registImplCls();

			//IPluginComponent Impl
			myPluginEntityImpl = ObjectFactoryUtil.createNewInstanceFromRegistedImplCls(IPluginEntity, null, this);
			
			super();
			
			if(stage != null)
			{
				initialize();
			}
			else
			{
				//ensure first to handle with
				this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler, false, int.MAX_VALUE);	
			}
        }
		
		//Template Method
		protected function registImplCls():void
		{
			ObjectFactoryUtil.registImplCls(IPluginEntity, PluginEntity);
			ObjectFactoryUtil.registImplCls(IRequestDriveAsynUpdater, RequestDriveAsynUpdater);
			ObjectFactoryUtil.registImplCls(ILayerChildrenManager, LayerChildrenManager);
			
			ObjectFactoryUtil.registImplCls(IMouseCursorDecorator, MouseCursorDecorator);
			ObjectFactoryUtil.registImplCls(IDragOnFly, DragOnFly);
			ObjectFactoryUtil.registImplCls(IInteractionMonitor, InteractionMonitor);
		}
		
		protected function onPreInitialize():void
		{
			myWidth = stage.stageWidth;
			myHeight = stage.stageHeight;
			
			myRequestDriveAsynUpdater = ObjectFactoryUtil.getSingletonIntance(IRequestDriveAsynUpdater);
			if(!myRequestDriveAsynUpdater)
			{
				myRequestDriveAsynUpdater = ObjectFactoryUtil.registSingletonInstance(IRequestDriveAsynUpdater, 
					new ClassFactory(RequestDriveAsynUpdater, {"setStage":[this["stage"]]}).newInstance());
			}
			
			myLayerChildrenManager = ObjectFactoryUtil.createNewInstanceFromRegistedImplCls(ILayerChildrenManager, null, this);
			
			onPreInitializeSystemPlugins();
			
			hasEventListener(ViburnumEvent.PRE_INITIALIZE)
			{
				dispatchEvent(new ViburnumEvent(ViburnumEvent.PRE_INITIALIZE));
			}
		}
		
		protected function onPreInitializeSystemPlugins():void
		{
			addPlugin(SystemStage.MOUSE_CURSOR_DECORATOR_NAME, 
				ObjectFactoryUtil.createNewInstanceFromRegistedImplCls(IMouseCursorDecorator));
			
			addPlugin(SystemStage.DRAG_ON_FLY_NAME, 
				ObjectFactoryUtil.createNewInstanceFromRegistedImplCls(IDragOnFly));
			
			addPlugin(SystemStage.INTERACTION_MONITOR_NAME, 
				ObjectFactoryUtil.createNewInstanceFromRegistedImplCls(IInteractionMonitor));
		}
		
		protected function onInitialize():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			
			stage.addEventListener(Event.RESIZE, stageResizeHandler, false, int.MAX_VALUE);
			
			if(hasEventListener(ViburnumEvent.INITIALIZE))
			{
				dispatchEvent(new ViburnumEvent(ViburnumEvent.INITIALIZE));
			}
		}
		
		protected function onInitializeComplete():void
		{
			if(hasEventListener(ViburnumEvent.INITIALIZE_COMPLETE))
			{
				dispatchEvent(new ViburnumEvent(ViburnumEvent.INITIALIZE_COMPLETE));
			}
		}
		
		protected function updateDisplayList():void
		{
			myLayerChildrenManager.setSize(myWidth, myHeight);
		}
		
		protected function stageResizeHandler(event:Event = null):void
		{
			setSize(stage.stageWidth, stage.stageHeight);
			myRequestDriveAsynUpdater.validateNow();
		}
		
		
		//IVirburnumDisplayObject Interface
		//Dead End
        override final public function get width():Number { return myWidth; }
        override final public function set width(value:Number):void { setSize(value, height); }
        override final public function get height():Number { return myHeight; }
        override final public function set height(value:Number):void { setSize(width, value); }
		public final function move(newX:Number, newY:Number):void {};
		override final public function set x(value:Number):void {};
		override final public function set y(value:Number):void {};

        public function setSize(newWidth:Number, newHeight:Number):void
        {
            var changed:Boolean = false;

            if(myWidth != newWidth)
            {
                myWidth = newWidth;
                changed = true;
            }

            if(myHeight != newHeight)
            {
                myHeight = newHeight;
                changed = true;
            }

            if(changed)
            {
				updateDisplayList();
				
				if(hasEventListener(Event.RESIZE))
				{
					dispatchEvent(new Event(Event.RESIZE));
				}
            }
        }

		//Dead End
		public final function get initialized():Boolean { return _initialized; }

		//ILayerLayoutChildrenManager Interface
		public function addChildToLayerByLayerName(child:DisplayObject, layerName:String):DisplayObject { return myLayerChildrenManager.addChildToLayerByLayerName(child, layerName); }
		public function removeChildFromLayerByLayerName(child:DisplayObject, layerName:String):DisplayObject { return myLayerChildrenManager.removeChildFromLayerByLayerName(child, layerName); }
		
		//IPluginEntity Interface
		public function addPlugin(pluginName:String, plugin:IPluginComponent):IPluginComponent { return myPluginEntityImpl.addPlugin(pluginName, plugin); }
		public function removePlugin(pluginName:String):IPluginComponent { return myPluginEntityImpl.removePlugin(pluginName); }
		public function hasPluginByName(pluginName:String):Boolean { return myPluginEntityImpl.hasPluginByName(pluginName); }
		public function getPluinByName(pluginName:String):IPluginComponent { return myPluginEntityImpl.getPluinByName(pluginName); }
		public function getPluinByType(type:Class):IPluginComponent { return myPluginEntityImpl.getPluinByType(type); }
		
		//event handler
		private function addToStageHandler(event:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		
			initialize();
		}
		
		private function initialize():void
		{
			if(!_initialized)
			{
				onPreInitialize();
				onInitialize();
				_initialized = true;
				onInitializeComplete();
			}
		}
    }
}