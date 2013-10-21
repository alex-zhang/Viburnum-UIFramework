package com.viburnum.components
{
	import com.viburnum.core.AsyValidatingClient;
	import com.viburnum.managers.ILayerChildrenManager;
	import com.viburnum.managers.LayerChildrenManager;
	import com.viburnum.core.PluginEntity;
	import com.viburnum.core.SystemStage;
	import com.viburnum.core.viburnum_internal;
	import com.viburnum.core.plugins.DragOnFly;
	import com.viburnum.core.plugins.MouseCursorDecorator;
	import com.viburnum.interfaces.IAsyValidatingClient;
	import com.viburnum.interfaces.IDragOnFly;
	import com.viburnum.interfaces.ILayoutElement;
	import com.viburnum.interfaces.IMouseCursorDecorator;
	import com.viburnum.interfaces.IPluginComponent;
	import com.viburnum.interfaces.IPluginEntity;
	import com.viburnum.lang.ILangManager;
	import com.viburnum.lang.LangManager;
	import com.viburnum.managers.FocusManager;
	import com.viburnum.managers.IFocusManager;
	import com.viburnum.managers.IPopupManager;
	import com.viburnum.managers.IToolTipManager;
	import com.viburnum.managers.PopupManager;
	import com.viburnum.managers.ToolTipManager;
	import com.viburnum.style.IStyleManager;
	import com.viburnum.style.StyleManager;
	import com.alex.utils.ObjectFactoryUtil;
	
	import flash.display.DisplayObject;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	use namespace viburnum_internal;
	
	public class Application extends SkinableContainer implements IApplication
	{
		public static const STYLE_MANAGER_NAME:String = "StyleManager";
		public static const LANG_MANGER_NAME:String = "LangManager";
		public static const TOOLTIP_MANAGER_NAME:String = "ToolTipManager";
		public static const POPUP_MANAGER_NAME:String = "PopupManager";
		
		//the type maybe Class(The Asset Clsss), String(The Asset Class Name) , Object(The Asset Proto Chain{})
		public var myDefaultThemeAssest:* = "HaloSkinTheme";
		public var myDefaultLangAssest:* = "Localezh_CNLang";
		
		protected var myPluginEntityImpl:PluginEntity;
		
		protected var mySystemStage:SystemStage;
		protected var myMouseCursorDecorator:IMouseCursorDecorator;
		protected var myDragOnFly:IDragOnFly;
		
		protected var myToolTipManager:IToolTipManager = null;
		protected var myPopupManager:IPopupManager = null;
		protected var myStyleManager:IStyleManager = null;
		protected var myLangManager:ILangManager = null;
		protected var myFocusManager:IFocusManager = null;
		
		protected var myLayerChildrenManager:ILayerChildrenManager;
		
		private var _screen:Rectangle;
		private var myLockContentInteractionCount:int = 0;
		
		public function Application()
		{
			registImplCls();
			
			//IPluginComponent Impl has regist in SystemStage
			myPluginEntityImpl = ObjectFactoryUtil
				.createNewInstanceFromRegistedImplCls(IPluginEntity, null, this) || new PluginEntity(this);
			
			super();
			
			myApplication = this;
			explicitCanSkipMeasure = true;
		}
		
		//Template Method
		protected function registImplCls():void
		{
			//System default use
			ObjectFactoryUtil.registImplCls(IAsyValidatingClient, AsyValidatingClient);
			
			ObjectFactoryUtil.registImplCls(IToolTipManager, ToolTipManager);
			ObjectFactoryUtil.registImplCls(IPopupManager, PopupManager);
			ObjectFactoryUtil.registImplCls(IStyleManager, StyleManager);
			ObjectFactoryUtil.registImplCls(ILangManager, LangManager);
			ObjectFactoryUtil.registImplCls(IFocusManager, FocusManager);
		}
		
		override protected function onPreInitialize():void
		{
			myLayerChildrenManager = ObjectFactoryUtil
				.createNewInstanceFromRegistedImplCls(ILayerChildrenManager, null, this) || new LayerChildrenManager(this);

			//---
			
			onPreInitializeSystem();
			onPreInitializeSystemPlugins();
			
			onPreInitializeApplicationPlugins();
			onPreInitializeApplicationDefaultResources();
			
			super.onPreInitialize();
		}
		
		protected function onPreInitializeSystem():void
		{
			if(systemStage == null)
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				stage.showDefaultContextMenu = false;
				
				stageResizeHandler(null);
				this.stage.addEventListener(Event.RESIZE, stageResizeHandler, false, int.MAX_VALUE);
			}
		}
		
		protected function onPreInitializeSystemPlugins():void
		{
			//registed from System stage
			//No SystemStage, we create it.
			myMouseCursorDecorator = mySystemStage ?
				mySystemStage.getPluinByName(SystemStage.MOUSE_CURSOR_DECORATOR_NAME) as IMouseCursorDecorator:
				addPlugin(SystemStage.MOUSE_CURSOR_DECORATOR_NAME, new MouseCursorDecorator()) as IMouseCursorDecorator;
			
			myDragOnFly = mySystemStage ? 
				mySystemStage.getPluinByName(SystemStage.DRAG_ON_FLY_NAME) as IDragOnFly:
				addPlugin(SystemStage.DRAG_ON_FLY_NAME, new DragOnFly()) as IDragOnFly;
		}
		
		protected function stageResizeHandler(event:Event = null):void
		{
			this.setSize(stage.stageWidth, stage.stageHeight);
		}
		
		protected function onPreInitializeApplicationPlugins():void
		{
			myStyleManager = addPlugin(Application.STYLE_MANAGER_NAME, 
				ObjectFactoryUtil.createNewInstanceFromRegistedImplCls(IStyleManager)) as IStyleManager;
			
			myLangManager = addPlugin(Application.LANG_MANGER_NAME, 
				ObjectFactoryUtil.createNewInstanceFromRegistedImplCls(ILangManager)) as ILangManager;
			
			myToolTipManager = addPlugin(Application.TOOLTIP_MANAGER_NAME, 
				ObjectFactoryUtil.createNewInstanceFromRegistedImplCls(IToolTipManager)) as IToolTipManager;
			
			myPopupManager = addPlugin(Application.POPUP_MANAGER_NAME, 
				ObjectFactoryUtil.createNewInstanceFromRegistedImplCls(IPopupManager)) as IPopupManager;
			
			myFocusManager = ObjectFactoryUtil.createNewInstanceFromRegistedImplCls(IFocusManager, null, this);
		}
		
		//初始化应用程序的 默认的主题样式, Locale等资源
		protected function onPreInitializeApplicationDefaultResources():void
		{
			try
			{
				if(myDefaultThemeAssest is String)
				{
					myDefaultThemeAssest = getDefinitionByName(String(myDefaultThemeAssest));
				}
				
				if(myDefaultThemeAssest is Class)
				{
					myDefaultThemeAssest.create(this, styleManager);
				}
				else if(myDefaultThemeAssest is Object)
				{
					styleManager.initStyleByPropChian(myDefaultThemeAssest);
				}
				
				//---
				
				if(myDefaultLangAssest is String)
				{
					myDefaultLangAssest = getDefinitionByName(myDefaultLangAssest);
				}
				
				if(myDefaultLangAssest is Class)
				{
					myDefaultLangAssest.create(this, langManager);
				}
				else if(myDefaultThemeAssest is Object)
				{
					langManager.initializeLocaleChain(null, myDefaultThemeAssest);
				}
			}
			catch(error:Error)
			{
			}
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			myLayerChildrenManager.setSize(layoutWidth, layoutHeight);
		}
		
		//IApplication Interface
		public function get screen():Rectangle
		{
			if(!_screen)
			{
				_screen = new Rectangle(0, 0, width, height);
			}
			else
			{
				_screen.x = 0;
				_screen.y = 0;
				_screen.width = width;
				_screen.height = height;
			}
			
			return _screen;
		}
		
		public function lockContentInteraction():void
		{
			myLockContentInteractionCount++;
			
			if(myLockContentInteractionCount == 1)
			{
				myContentGroup.mouseEnabled = false;
				myContentGroup.mouseChildren = false;
			}
		}
		
		public function unLockContentInteraction():void
		{
			if(myLockContentInteractionCount == 0) return;
			
			myLockContentInteractionCount--;
			
			if(myLockContentInteractionCount == 0)
			{
				myContentGroup.mouseEnabled = true;
				myContentGroup.mouseChildren = true;
			}
		}
		
		//IPluginEntity Interface
		public function addPlugin(pluginName:String, plugin:IPluginComponent):IPluginComponent { return myPluginEntityImpl.addPlugin(pluginName, plugin); }
		public function removePlugin(pluginName:String):IPluginComponent { return myPluginEntityImpl.removePlugin(pluginName); }
		public function hasPluginByName(pluginName:String):Boolean { return myPluginEntityImpl.hasPluginByName(pluginName); }
		public function getPluinByName(pluginName:String):IPluginComponent { return myPluginEntityImpl.getPluinByName(pluginName); }
		public function getPluinByType(type:Class):IPluginComponent { return myPluginEntityImpl.getPluinByType(type); }
		//IPluginComponent Interface
		public function get pluginEntity():IPluginEntity { return mySystemStage; }
		public function set pluginEntity(value:IPluginEntity):void { mySystemStage = value as SystemStage; }

		public function onAttachToPluginEntity():void {}
		public function onDettachFromPluginEntity():void {}
		
		//ILayerLayoutChildrenManager Interface
		public function addChildToLayerByLayerName(child:DisplayObject, layerName:String):DisplayObject { return myLayerChildrenManager.addChildToLayerByLayerName(child, layerName); }
		public function removeChildFromLayerByLayerName(child:DisplayObject, layerName:String):DisplayObject { return myLayerChildrenManager.removeChildFromLayerByLayerName(child, layerName); }
		
		//Dead End
		override final public function get systemStage():SystemStage { return mySystemStage; }
		override final public function get mouseCursorDecorator():IMouseCursorDecorator { return myMouseCursorDecorator; }
		override final public function get dragOnFly():IDragOnFly { return myDragOnFly; }
		override final public function get toolTipManager():IToolTipManager { return myToolTipManager; }
		override final public function get langManager():ILangManager { return myLangManager; }
		override final public function get popupManager():IPopupManager { return myPopupManager; }
		override final public function get styleManager():IStyleManager { return myStyleManager; }
		override final public function get focusManager():IFocusManager { return myFocusManager; }
		override final public function set errorString(value:String):void {};
	}
}