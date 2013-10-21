package com.viburnum.components
{
    import com.viburnum.core.SystemStage;
    import com.viburnum.interfaces.IAsyValidatingClient;
    import com.viburnum.interfaces.IDragOnFly;
    import com.viburnum.interfaces.IMouseCursorDecorator;
    import com.viburnum.lang.ILangManager;
    import com.viburnum.managers.IFocusManager;
    import com.viburnum.managers.IPopupManager;
    import com.viburnum.managers.IToolTipManager;
    import com.viburnum.style.IStyleManager;
    
    import flash.display.DisplayObjectContainer;
    import flash.events.IEventDispatcher;

    public interface IUIComponent extends IAsyValidatingClient, IEventDispatcher
    {
		/**
		 * 返回组件是否禁用 
		 */	
		function get enabled():Boolean;
		
		/**
		 * 设置组件是否禁用 
		 */	
		function set enabled(value:Boolean):void;
			
		/**
		 * 返回组件是否被Popupmanager popup.
		 */	
        function get isPopUp():Boolean;
		
		/**
		 * 设置组件是否被Popupmanager popup, 由框架调用.
		 */	
        function set isPopUp(value:Boolean):void;

		/**
		 * 该组件的所有者，可能不是父子层级关系. 
		 */		
        function get owner():DisplayObjectContainer;
		
		/**
		 * 设置组件的所有者. 
		 */	
        function set owner(value:DisplayObjectContainer):void;

		/**
		 * 返回 application.
		 * 
		 * @see com.viburnum.interfaces.IApplication
		 * 
		 * @return IApplication
		 * 
		 */	
        function get application():IApplication;
		
		/**
		 * 设置组件是否可见 
		 */	
		function setVisible(value:Boolean):void;
		
		/**
		 * 获取SystemStage
		 * 
		 * @see com.viburnum.core.SystemStage
		 * 
		 * @return SystemStage
		 * 
		 */	
		function get systemStage():SystemStage

		/**
		 * 获取ISystemStage上的ICursorDecorator Helper.
		 * 
		 * @see com.viburnum.core.IMouseCursorDecorator
		 * 
		 * @return IMouseCursorDecorator
		 * 
		 */		
		function get mouseCursorDecorator():IMouseCursorDecorator;
		
		/**
		 * 获取ISystemStage上的IDragOnFly Helper. 
		 * 
		 * @see com.viburnum.core.IDragOnFly
		 * 
		 * @return IDragOnFly
		 * 
		 */	
		function get dragOnFly():IDragOnFly;

		/**
		 * 获取IApplication上的IToolTipManager Helper. 
		 * 
		 * @see com.viburnum.managers.IToolTipManager
		 * 
		 * @return IToolTipManager
		 * 
		 */	
		function get toolTipManager():IToolTipManager;
		
		/**
		 * 获取IApplication上的IResourceManager Helper. 
		 * 
		 * @see com.viburnum.managers.IResourceManager
		 * 
		 * @return IResourceManager
		 * 
		 */
		function get langManager():ILangManager;
		
		/**
		 * 获取IApplication上的IPopupManager Helper. 
		 * 
		 * @see com.viburnum.managers.IPopupManager
		 * 
		 * @return IPopupManager
		 * 
		 */	
		function get popupManager():IPopupManager;
		
		/**
		 * 获取IApplication上的IStyleManager Helper. 
		 * 
		 * @see com.viburnum.managers.IStyleManager
		 * 
		 * @return IStyleManager
		 * 
		 */	
		function get styleManager():IStyleManager;
		
		/**
		 * 获取IFocusManager Helper. 
		 * 
		 * <p>IApplication会维持一个IFocusManager，Container也可能会有自己的IFocusManager</p>
		 * 
		 * @see com.viburnum.managers.IFocusManager
		 * 
		 * @return IFocusManager
		 * 
		 */	
		function get focusManager():IFocusManager;
    }
}