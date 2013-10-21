package com.viburnum.managers
{
    import com.viburnum.components.Application;
    import com.viburnum.components.IApplication;
    import com.viburnum.components.IFocusManagerContainer;
    import com.viburnum.components.IUIComponent;
    import com.viburnum.core.SystemStage;
    import com.viburnum.core.viburnum_internal;
    import com.viburnum.interfaces.IPluginEntity;
    import com.viburnum.layouts.PositionConstrainType;
    import com.alex.utils.ObjectFactoryUtil;
    
    import flash.display.DisplayObject;
    import flash.display.Sprite;

    public class PopupManager implements IPopupManager
    {
		public static const POPUP_LAYER_NAME:String = "popupLayer";
		
		protected var myApplication:IApplication;
		protected var popUpLayer:PopupLayer;
		
        public function PopupManager()
        {
            super();
        }
		
		//IPluginComponent Interface
		public function get pluginEntity():IPluginEntity
		{
			return myApplication;
		}
		
		public function set pluginEntity(value:IPluginEntity):void
		{
			myApplication = value as IApplication;
		}
		
		public function onAttachToPluginEntity():void
		{
			if(!popUpLayer) popUpLayer = createPopupLayer() as PopupLayer;
			
			popUpLayer.application = myApplication;
			
			myApplication.addChildToLayerByLayerName(popUpLayer, LayerChildrenNames.MIDDLE_LAYER_NAME);
		}
		
		protected function createPopupLayer():Sprite
		{
			var s:Sprite = new PopupLayer();
			s.name = POPUP_LAYER_NAME;
			
			return s;
		}
		
		public function onDettachFromPluginEntity():void
		{
			popUpLayer.application = null;
			myApplication.removeChildFromLayerByLayerName(popUpLayer, LayerChildrenNames.MIDDLE_LAYER_NAME);
		}

        //IPopupManager Interface===============================================
		public function getModalWindowCount():int
		{
			if(popUpLayer == null) return 0;
			
			return popUpLayer.getModalWindowCount();
		}
		
        public function addPopUp(window:DisplayObject, modal:Boolean = false, modalAlpha:Number = NaN):void
        {
			if(!window || hasWindow(window)) return;
			
			if(window is IUIComponent)
			{
				IUIComponent(window).isPopUp = true;
			}
			
			if(modal && window is IFocusManagerContainer)
			{
				var focusManager:IFocusManager = ObjectFactoryUtil.createNewInstanceFromRegistedImplCls(IFocusManager, null, window);
				
				IFocusManagerContainer(window).focusManager = focusManager;
			}

			popUpLayer.addPopUp(window, modal, modalAlpha); 
        }
		
        public function bringToFront(window:DisplayObject):void
        {
			popUpLayer.bringToFront(window);
        }
		
		public function bringToBack(window:DisplayObject):void
		{
			popUpLayer.bringToBack(window);
		}

		public function constrainPostion(window:DisplayObject, constrainType:String = PositionConstrainType.CUSTOM, 
										 isAlwaysConstrain:Boolean = false):void
		{
			popUpLayer.constrainPostion(window, constrainType, isAlwaysConstrain);
		}
		
		public function centerPopUp(window:DisplayObject, isAlwaysPopupCenter:Boolean = false):void
		{
			constrainPostion(window, PositionConstrainType.CENTER, isAlwaysPopupCenter);
		}

        public function removePopUp(window:DisplayObject):void
        {
			if(window is IUIComponent)
			{
				IUIComponent(window).isPopUp = false;
			}
			
			popUpLayer.removePopUp(window);
			
			activeApplicationFocusManagerWhenNoneModalWindow();
        }
		
		viburnum_internal function removeAllPopUpChildren():void
		{
			if(popUpLayer == null) return;
			
			popUpLayer.viburnum_internal::removeAllPopUpChildren();
			
			activeApplicationFocusManagerWhenNoneModalWindow();
		}
		
		private function activeApplicationFocusManagerWhenNoneModalWindow():void
		{
			if(getModalWindowCount() == 0 && 
				myApplication != null && myApplication.focusManager != null)
			{
				myApplication.focusManager.activate();
			}
		}

		public function hasWindow(window:DisplayObject):Boolean
		{
			return popUpLayer.hasWindow(window);
		}
    }
}