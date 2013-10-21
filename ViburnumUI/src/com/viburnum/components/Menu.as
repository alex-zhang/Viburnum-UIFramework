package com.viburnum.components
{
    import com.viburnum.components.baseClasses.ListBase;
    import com.viburnum.components.supportClasses.MenuItemRenderer;
    import com.alex.utils.ClassFactory;
    import com.viburnum.core.viburnum_internal;
    import com.viburnum.data.IHiberarchyNode;
    import com.viburnum.data.IList;
    import com.viburnum.events.CollectionEvent;
    import com.viburnum.events.ListEvent;
    import com.viburnum.events.ViburnumMouseEvent;
    import com.viburnum.layouts.PositionConstrainType;
    import com.viburnum.utils.LayoutUtil;
    
    import flash.display.DisplayObject;
    import flash.geom.Point;
	
    public class Menu extends ListBase
    {
		public static function createMenu(dataProvider:IList = null, 
										  application:IApplication = null, isHiddedWhenClickOutSide:Boolean = true):Menu
		{
			var menu:Menu = new Menu();
			menu.dataProvider = dataProvider;
			menu.isHiddedWhenClickOutSide = isHiddedWhenClickOutSide;
			popUpMenu(menu, application);
			
			return menu;
		}

		public static function popUpMenu(menu:Menu, application:IApplication):void
		{
			if(application != null && application.popupManager != null && !application.popupManager.hasWindow(menu))
			{
				application.popupManager.addPopUp(menu, false);
				application.popupManager.constrainPostion(menu, PositionConstrainType.CUSTOM_LIMITED);
			}
		}

		private var _typeField:String = "type";
		private var _disabledField:String = "disabled";
		private var _toggledField:String = "toggle";
		private var _groupNameFiled:String = "groupName";

		public var isHiddedWhenClickOutSide:Boolean = true;
		
		private var _parentMenu:Menu = null;
		private var _currentShowedSubMenu:Menu = null;
		
		//当前Menu的所有子Menu的map缓存 index => Menue
		private var _allSubMenusCache:Array = [];

        public function Menu()
        {
            super();

			itemRenderer = new ClassFactory(MenuItemRenderer);//default

			visible = false;//default
			
			this.addEventListener(ListEvent.ITEM_RENDER_ROLL_OVER, itemRenderRollOverHandler);
			this.addEventListener(ListEvent.ITEM_RENDER_CLICK, itemRenderClickHandler);
        }
		
		public function get typeField():String
		{
			return _typeField;
		}
		
		public function set typeField(value:String):void
		{
			_typeField = value;
		}
		
		public function get disabledField():String
		{
			return _disabledField;
		}
		
		public function set disabledField(value:String):void
		{
			_toggledField = value;
		}
		
		public function get toggledField():String
		{
			return _toggledField;
		}
		
		public function set toggledField(value:String):void
		{
			_toggledField = value;
		}
		
		public function get groupNameFiled():String
		{
			return _groupNameFiled;
		}
		
		public function set groupNameFiled(value:String):void
		{
			_groupNameFiled = value;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			if(isHiddedWhenClickOutSide && getRootMenu() == this)
			{
				this.addEventListener(ViburnumMouseEvent.POPUP_CHILD_MOUSE_DOWN_OUTSIDE, popupChildMouseDownOutSideHandler);
			}
		}

		public function get parentMenu():Menu
		{
			return _parentMenu;
		}
		
		public function set parentMenu(value:Menu):void
		{
			_parentMenu = value;
		}
		
		public function getRootMenu():Menu
		{
			var target:Menu = this;

			while(target.parentMenu != null)
			{
				target = target.parentMenu;
			}

			return target;
		}
		
		public function show():void
		{
			if(this.visible || (_parentMenu != null && _parentMenu.visible == false)) return;

			LayoutUtil.setDisplayObjectVisiable(this, true);
		}

		public function showXY(x:Number, y:Number):void
		{
			show();
			
			LayoutUtil.setDisplayObjectPosition(this, x, y);
		}

		public function hide():void
		{
			if(this.visible)
			{
				setVisible(false);
				
				hideCurrentShowedSubMenu();
			}
		}
		
		private function hideCurrentShowedSubMenu():void
		{
			if(_currentShowedSubMenu != null)
			{
				_currentShowedSubMenu.hide();
				_currentShowedSubMenu = null;
			}
		}

		public function destory():void
		{
			//只有根Menu才可以删除
			if(getRootMenu() == this)
			{
				viburnum_internal::innerdestory();
			}
		}

		viburnum_internal function innerdestory():void
		{
			//remove self from displaylist
			if(popupManager != null && popupManager.hasWindow(this))
			{
				popupManager.removePopUp(this);
			}
			
			for each(var subMenu:Menu in _allSubMenusCache)
			{
				if(subMenu != null)
				{
					subMenu.viburnum_internal::innerdestory();
				}
			}
			
			clearSubMenucache();
		}
		
		private function createAndShowSubMenuByItemRender(itemrender:IItemRender):void
		{
			hideCurrentShowedSubMenu();
			
			if(itemrender == null || dataProvider == null) return;
			var itemIndex:int = itemrender.itemIndex;
			var itemData:Object = itemrender.data;
			
			if(itemData != null && 
				itemData is IHiberarchyNode && IHiberarchyNode(itemData).hasChildren())
			{
				if(hasSubMenuInCache(itemIndex))
				{
					_currentShowedSubMenu = getSubMenuFromCache(itemIndex);
				}
				else
				{
					var subMnenuDataprovider:IList = IHiberarchyNode(itemData).getChildren();
					_currentShowedSubMenu = Menu.createMenu(subMnenuDataprovider, application, false);
					_currentShowedSubMenu.parentMenu = getRootMenu() == this ? this : _parentMenu;
				}
				
				var p:Point = new Point(itemrender.x + itemrender.width, itemrender.y);
				p = application.globalToLocal(localToGlobal(p));
				
				if(_currentShowedSubMenu != null)
				{
					_currentShowedSubMenu.showXY(p.x, p.y);
				}
			}
		}

		private function addSubMenuToCache(index:int, subMenu:Menu):void
		{
			_allSubMenusCache[index] = subMenu;
		}
		
		private function removeSubMenuFromCache(index:int):void
		{
			_allSubMenusCache[index] = null;
		}
		
		private function hasSubMenuInCache(index:int):Boolean
		{
			return _allSubMenusCache[index] != null;
		}
		
		private function getSubMenuFromCache(index:int):Menu
		{
			return _allSubMenusCache[index];
		}
		
		private function clearSubMenucache():void
		{
			_allSubMenusCache = [];
		}

		override public function OnUpdateItemRender(render:DisplayObject, itemIndex:int, itemData:Object):void
		{
			super.OnUpdateItemRender(render, itemIndex, itemData);
			
			if(render is IMenuItemRenderer)
			{
				var type:String = String(itemToValueByKeyField(itemData, typeField) || MenuItemType.LABEL).toLowerCase();
				var disabled:Boolean = String(itemToValueByKeyField(itemData, disabledField) || "false").toLowerCase() == "true";
				var toggled:Boolean = String(itemToValueByKeyField(itemData, disabledField) || "false").toLowerCase() == "true";
				var groupName:String = String(itemToValueByKeyField(itemData, disabledField) || "").toLowerCase();

				IMenuItemRenderer(render).type = type;
				IMenuItemRenderer(render).disabled = disabled;
				IMenuItemRenderer(render).toggled = toggled;
				IMenuItemRenderer(render).groupName = groupName;
				
				IMenuItemRenderer(render).hasBranch = checkItemDataHasBranch(itemData);
			}
		}
		
		override public function onListDataProviderCollectionChange(event:CollectionEvent):void
		{
			//暂时取消一切数据变化的处理
			event.preventDefault();
		}
		
		protected function checkItemDataHasBranch(itemData:Object):Boolean
		{
			if(itemData is IHiberarchyNode)
			{
				return IHiberarchyNode(itemData).hasChildren();
			}
			
			return false;
		}

		//needToCheck
		override protected function itemSelected(lastSelectedIndex:int, currentSelectedIndex:int):void
		{
			var currentSelectedRenderItem:MenuItemRenderer = DataGroup(myContentGroup).getLayoutChildAt(currentSelectedIndex) as MenuItemRenderer;
			var lastSelectedRenderItem:MenuItemRenderer = DataGroup(myContentGroup).getLayoutChildAt(lastSelectedIndex) as MenuItemRenderer;
			
			var currentSelectedRenderItemGroupName:String;

			if(currentSelectedRenderItem != null && 
				(currentSelectedRenderItem.type == MenuItemType.CHECK || currentSelectedRenderItem.type == MenuItemType.RADIO))
			{
				if(currentSelectedRenderItem.type == MenuItemType.CHECK)
				{
					currentSelectedRenderItem.selected = !currentSelectedRenderItem.selected;
					return;
				}
				else if(currentSelectedRenderItem.type == MenuItemType.RADIO)
				{
					currentSelectedRenderItem.selected = true;
					currentSelectedRenderItemGroupName = currentSelectedRenderItem.type == MenuItemType.RADIO ? currentSelectedRenderItem.groupName : null;	
				}
			}
			
			if(lastSelectedRenderItem != null && lastSelectedRenderItem.type == MenuItemType.RADIO && (lastSelectedRenderItem.groupName == currentSelectedRenderItemGroupName))
			{
				lastSelectedRenderItem.selected = false;
			}
		}
		
		//event handelr
		private function itemRenderRollOverHandler(event:ListEvent):void
		{
			var render:IItemRender = event.itemRender;
			
			createAndShowSubMenuByItemRender(render);
		}
		
		private function itemRenderClickHandler(event:ListEvent):void
		{
			var render:IItemRender = event.itemRender;
			if(render != null && render is IMenuItemRenderer && 
				(IMenuItemRenderer(render).type == MenuItemType.RADIO || IMenuItemRenderer(render).type == MenuItemType.CHECK))
			{
				if(IMenuItemRenderer(render).type == MenuItemType.RADIO && render.selected) return;
				
				selectedIndex = render.itemIndex;
			}
			
			if(getRootMenu() != null)
			{
				getRootMenu().hide();
			}
		}
		
		private function popupChildMouseDownOutSideHandler(event:ViburnumMouseEvent):void
		{
			if(getRootMenu() == this)
			{
				var relatedObject:DisplayObject = event.relatedObject;//被点击的对象
				if(_currentShowedSubMenu == null || !_currentShowedSubMenu.contains(relatedObject))
				{
					hide();
				}
			}
		}
    }
}