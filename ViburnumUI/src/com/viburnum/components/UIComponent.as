package com.viburnum.components
{
    import com.viburnum.core.LayoutSpriteElement;
    import com.viburnum.core.SystemStage;
    import com.viburnum.events.ViburnumEvent;
    import com.viburnum.interfaces.IDragOnFly;
    import com.viburnum.interfaces.IMouseCursorDecorator;
    import com.viburnum.interfaces.IStyleNotifyer;
    import com.viburnum.lang.ILangManager;
    import com.viburnum.managers.IFocusManager;
    import com.viburnum.managers.IPopupManager;
    import com.viburnum.managers.IToolTipManager;
    import com.viburnum.skins.ISkin;
    import com.viburnum.style.IStyleManager;
    import com.alex.utils.NameUtil;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    
	/**
	 * 当组件被popup后在非组件的显示列表中点击会触发该事件.
	 */	
	[Event(name="popupChildMouseDownOutSide", type="com.viburnum.events.ViburnumMouseEvent")]
	
	/**
	 * 在框架的目标toolTip开始创建会调用该事件. 
	 */	
	[Event(name="toolTipCreate", type="com.viburnum.events.ToolTipEvent")]
	
	/**
	 * 在框架的目标toolTip销毁时会调用该事件 
	 */	
	[Event(name="toolTipDestory", type="com.viburnum.events.ToolTipEvent")]
	
	/**
	 * 在IDragOnFly拖动下进入该对象. 
	 */	
	[Event(name="dragEnter", type="com.viburnum.events.DragEvent")]
	
	/**
	 * 在IDragOnFly拖动下在该对象中移动 
	 */	
	[Event(name="dragMove", type="com.viburnum.events.DragEvent")]
	
	/**
	 *  在IDragOnFly拖动下移出该对象 
	 */	
	[Event(name="dragExit", type="com.viburnum.events.DragEvent")]
	/**
	 * UIComponent 类是所有可视组件（交互式和非交互式）的基类.
	 * 
	 * <p>交互式组件可以参与 Tab 切换和其它几种键盘焦点处理，接受低级事件（如键盘和鼠标输入），还可以被禁用，以便该组件不能收到键盘和鼠标输入。
	 * 这与非交互式组件（如 Label 和 ProgressBar）相反，非交互式组件只显示内容且不能由用户操作。</p>
	 * 
	 * @author zhangcheng01
	 * 
	 */
    public class UIComponent extends LayoutSpriteElement implements IUIComponent, 
																		IToolTipClient,
																		IChildrenStyleNotifyer
    {
        protected var myApplication:IApplication;
		
		private var _owner:DisplayObjectContainer;

        private var _isPopUp:Boolean = false;
		private var _popupLayerPriority:int = 0;
		
        private var _toolTip:String = null;
		private var _toolTipEnable:Boolean = true;//默认打开

		private var _enabled:Boolean = true;
		private var _enabledChangedFlag:Boolean = false;

		private var _visible:Boolean = true;
		
		/**
		 *  构造函数
		 */
        public function UIComponent()
        {
            super();
			
			delwithChildrenInConstractor();
			
			super.visible = false;//visible later
        }
		
		protected function delwithChildrenInConstractor():void
		{
			super.removeChildren();
		}
		
		//======================================================================
		//Just For IDE Inspectable
		[Inspectable(type="Number", defaultValue="1", minValue="0", maxValue="1")]
		override public function set alpha(value:Number):void
		{
			super.alpha = value;
		}
		
		[Inspectable(type="Boolean", defaultValue="false")]
		override public function set cacheAsBitmap(value:Boolean):void
		{
			super.cacheAsBitmap = value;
		}
		
		[Inspectable(type="Boolean", defaultValue="false")]
		override public function set buttonMode(value:Boolean):void
		{
			super.buttonMode = value;
		}
		
		[Inspectable(type="Boolean")]
		override public function set opaqueBackground(value:Object):void
		{
			super.opaqueBackground = value;
		}
		//=====================================================================
		
		//IUIComponent Interface================================================
		/**
		 * 返回组件是否被Popupmanager popup.
		 */		
        public function get isPopUp():Boolean
        {
            return _isPopUp;
        }
        
		/**
		 * 设置组件是否被Popupmanager popup, 由框架调用.
		 */		
        public function set isPopUp(value:Boolean):void
        {
            _isPopUp = value;
        }
		
		/**
		 * PopupLayer 中的排序参考 
		 * @return 
		 * 
		 */		
		public function get popupLayerPriority():int
		{
			return _popupLayerPriority;
		}
		
		[Inspectable(type="number")]
		public function set popupLayerPriority(value:int):void
		{
			_popupLayerPriority = value;
		}
        
		/**
		 * 返回 application.
		 * 
		 * @see com.viburnum.interfaces.IApplication
		 * 
		 * @return IApplication
		 * 
		 */		
        public function get application():IApplication
        {
            return myApplication;
        }

		/**
		 * 返回组件是否禁用 
		 */	
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * 设置组件是否禁用 
		 */		
		[Inspectable(type="Boolean")]
		public function set enabled(value:Boolean):void
		{
			if(_enabled != value)
			{
				_enabled = value;
				_enabledChangedFlag = true;
				invalidateProperties();
			}
		}
		
		public function get systemStage():SystemStage
		{
			return myApplication != null ?
				myApplication.systemStage :
				null; 
		}

		/**
		 * 获取ISystemStage上的ICursorDecorator Helper.
		 * 
		 * @see com.viburnum.core.ICursorDecorator
		 * 
		 * @return cursorDecorator
		 * 
		 */		
		public function get mouseCursorDecorator():IMouseCursorDecorator
		{
			return myApplication != null ?
				myApplication.mouseCursorDecorator :
				null;
		}

		/**
		 * 获取ISystemStage上的IDragOnFly Helper. 
		 * 
		 * @see com.viburnum.core.IDragOnFly
		 * 
		 * @return dragOnFly
		 * 
		 */		
		public function get dragOnFly():IDragOnFly
		{
			return myApplication != null ?
				myApplication.dragOnFly :
				null;
		}

		/**
		 * 获取IApplication上的IToolTipManager Helper. 
		 * 
		 * @see com.viburnum.managers.IToolTipManager
		 * 
		 * @return IToolTipManager
		 * 
		 */	
		public function get toolTipManager():IToolTipManager
		{
			return myApplication != null ?
				myApplication.toolTipManager :
				null;
		}

		/**
		 * 获取IApplication上的IResourceManager Helper. 
		 * 
		 * @see com.viburnum.managers.IResourceManager
		 * 
		 * @return IResourceManager
		 * 
		 */	
		public function get langManager():ILangManager
		{
			return myApplication != null ?
				myApplication.langManager :
				null;
		}

		/**
		 * 获取IApplication上的IPopupManager Helper. 
		 * 
		 * @see com.viburnum.managers.IPopupManager
		 * 
		 * @return IPopupManager
		 * 
		 */	
		public function get popupManager():IPopupManager
		{
			return myApplication != null ?
				myApplication.popupManager :
				null;
		}

		/**
		 * 获取IApplication上的IStyleManager Helper. 
		 * 
		 * @see com.viburnum.managers.IStyleManager
		 * 
		 * @return IStyleManager
		 * 
		 */	
		public function get styleManager():IStyleManager
		{
			return myApplication != null ?
				myApplication.styleManager :
				null;
		}

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
		public function get focusManager():IFocusManager
		{
			var o:DisplayObjectContainer = parent;
			
			while(o != null)
			{
				if(o is IFocusManagerContainer)
				{
					if(IFocusManagerContainer(o).focusManager != null)
					{
						return IFocusManagerContainer(o).focusManager;
					}
				}

				if(o is IUIComponent && IUIComponent(o).owner != null)
				{
					o = IUIComponent(o).owner;
				}
				else
				{
					o = o.parent;	
				}
			}

			return null;
		}
		
		/**
		 * @private 
		 */		
		override public function get visible():Boolean
		{
			return _visible;
		}
		
		/**
		 * @private 
		 */
		[Inspectable(type="Boolean", defaultValue="true")]
		override public function set visible(value:Boolean):void
		{
			setVisible(value);
		}

		/**
		 * 设置组件是否可见 
		 */		
		public function setVisible(value:Boolean):void
		{
			_visible = value;
			
			if(!createCompleted || super.visible == value) return;
			
			super.visible = _visible;
			
			if(hasEventListener(ViburnumEvent.SHOW) || hasEventListener(ViburnumEvent.HIDE))
			{
				dispatchEvent(new ViburnumEvent(_visible ? ViburnumEvent.SHOW : ViburnumEvent.HIDE));
			}
		}
		
        //IToolTipClient Interface=======================================
		/**
		 * 返回tip 
		 */		
        public function get toolTip():String
        {
            return _toolTip;
        }
        
		/**
		 * 设置tip 供框架显示ToolTip时调用.
		 */		
		[Inspectable(type="String")]
        public function set toolTip(value:String):void
        {
            if(_toolTip != value)
            {
				_toolTip = value;
				
				if(_toolTipEnable && toolTipManager != null && 
					toolTipManager.currentToolTipClient == this && 
					toolTipManager.currentToolTip != null)
				{
					//update current toolTip
					toolTipManager.currentToolTip.toolTip = _toolTip;
				}
            }
        }
		
		/**
		 * 获取是否允许框架tip.
		 */		
		public function get toolTipEnable():Boolean
		{
			return _toolTipEnable;
		}
		
		/**
		 * 设置是否允许框架tip.
		 */		
		[Inspectable(type="Boolean")]
		public function set toolTipEnable(value:Boolean):void
		{
			if(_toolTipEnable != value)
			{
				_toolTipEnable = value;
				
				if(toolTipManager != null)
				{
					if(_toolTipEnable)
					{
						toolTipManager.registToolTipClient(this);
					}
					else
					{
						toolTipManager.unRegistToolTipClient(this);
					}
				}
			}
		}
		
		//IChildrenStyleNotifyer Interface=====================================================
		/**
		 * @private
		 * UICompoentn 本身没有定义样式，但是当继承样式发生改变时需要向其所有children发送通知.
		 * 
		 * <p>保证样式的传递链,穿透非SkinableComponent</p>
		 * 
		 * @param styleProp
		 * @param recursive
		 * 
		 */		
		public function notifyStyleChangedInChildren(styleProp:String, recursive:Boolean):void
		{
			var n:int = numChildren;
			for(var i:uint = 0; i < n; i++)
			{
				//本框架中对显示列表的取操作未做任何的覆盖，始终保证显示列表的可访问性
				var child:DisplayObject = getChildAt(i);
				if(child is IStyleNotifyer)
				{
					if(child is ISkin && ISkin(child).skinPartName != null)
					{
						if(ISkin(child).skinPartName != styleProp && 
							styleProp.indexOf(ISkin(child).skinPartName) != -1)//Skin name
						{
							IStyleNotifyer(child).notifyStyleChanged(ISkin(child).getSkinPartStyleProp(styleProp));
						}
					}
					else
					{
						IStyleNotifyer(child).notifyStyleChanged(styleProp);
					}
				}
				
				if(recursive && child is IChildrenStyleNotifyer)
				{
					IChildrenStyleNotifyer(child).notifyStyleChangedInChildren(styleProp, recursive);	
				}
			}
		}
		
		override public function toString():String
		{
			return NameUtil.displayObjectToString(this);
		}
		
		/**
		 *  @private
		 *  整体换肤机制, 但是是app创建完成后，保证传递链,穿透非SkinableComponent.
		 * 
		 *  @param needUpdateSkinImmediately
		 * 
		 */		
		public function regenerateStyleCache(needUpdateSkinImmediately:Boolean):void
		{
			var n:int = numChildren;
			for(var i:uint = 0; i < n; i++)
			{
				var child:DisplayObject = getChildAt(i);
				if(child is IChildrenStyleNotifyer)
				{
					IChildrenStyleNotifyer(child).regenerateStyleCache(needUpdateSkinImmediately);
				}
			}
		}

		override protected function onPreInitialize():void
		{
			super.onPreInitialize();
			
			if(hasEventListener(ViburnumEvent.PRE_INITIALIZE))
			{
				dispatchEvent(new ViburnumEvent(ViburnumEvent.PRE_INITIALIZE));
			}
		}
		
		override protected function onInitialize():void
		{ 
			if(hasEventListener(ViburnumEvent.INITIALIZE))
			{
				dispatchEvent(new ViburnumEvent(ViburnumEvent.INITIALIZE));
			}
		}
		
		override protected function onInitializeComplete():void
		{
			if(langManager != null)
			{
				langManager.addEventListener(Event.CHANGE, resourceChangedHandler, false, 0, true);
			}
			
			if(hasEventListener(ViburnumEvent.INITIALIZE_COMPLETE))
			{
				dispatchEvent(new ViburnumEvent(ViburnumEvent.INITIALIZE_COMPLETE));
			}
		}
		
		/**
		 * @private 
		 */	
		override protected function onCreateComplete():void
		{
			setVisible(_visible);
			
			if(hasEventListener(ViburnumEvent.CREATION_COMPLETE))
			{
				dispatchEvent(new ViburnumEvent(ViburnumEvent.CREATION_COMPLETE));
			}
		}

		/**
		 * @private 
		 */	
		override protected function onValidateProperties():void
		{
			super.onValidateProperties();
				
			if(_enabledChangedFlag)
			{
				_enabledChangedFlag = false;
				enableChanged();
			}
		}
		
		/**
		 * @private 
		 */		
		protected function enableChanged():void
		{
			for(var i:int = 0, n:int = numChildren; i < n; i++)
			{
				var child:DisplayObject = getChildAt(i);
				
				if(child is IUIComponent)
				{
					IUIComponent(child).enabled = _enabled;
				}
			}
		}
		
		/**
		 * @private 
		 */		
		override protected function onAttachToDisplayList():void
		{
			super.onAttachToDisplayList();
			
			if(!(this is IApplication))
			{
				var p:DisplayObjectContainer = this.parent;
				while(p != null)
				{
					if(p is IUIComponent)
					{
						myApplication = IUIComponent(p).application;
						break;
					}
					p = p.parent;
				}
			}
			
			if(focusManager != null && this is IFocusManagerComponent)
			{
				focusManager.registFocusManagerComponent(IFocusManagerComponent(this));
			}
			
			if(toolTipManager != null && _toolTipEnable && _toolTip != null)
			{
				toolTipManager.registToolTipClient(this);
			}
		}

		/**
		 * @private 
		 */		
		override protected function onDetachFromDisplayList():void
		{
			if(focusManager != null && this is IFocusManagerComponent)
			{
				focusManager.unRegistFocusManagerComponent(IFocusManagerComponent(this));
			}
			
			if(toolTipManager != null)
			{
				toolTipManager.unRegistToolTipClient(this);
			}

			myApplication = null;
		}
		
		//event handle
		protected function resourceChangedHandler(event:Event):void {};
    }
}