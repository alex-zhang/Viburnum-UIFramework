package com.viburnum.components.baseClasses
{
	import com.viburnum.components.DataGroup;
	import com.viburnum.components.IItemRender;
	import com.viburnum.components.SkinableDataContainer;
	import com.viburnum.events.ListEvent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	[Event(name="itemRenderRollOver", type="com.viburnum.events.ListEvent")]
	[Event(name="itemRenderRollOut", type="com.viburnum.events.ListEvent")]
	[Event(name="itemRenderMouseDown", type="com.viburnum.events.ListEvent")]
	[Event(name="itemRenderClick", type="com.viburnum.events.ListEvent")]
	[Event(name="itemRenderDoubleClick", type="com.viburnum.events.ListEvent")]

    public class ListBase extends SkinableDataContainer
    {
		private var _selectedIndex:int = -1;
		private var _lastSelectedIndex:int = -1;
		private var _selectedIndexChangedFlag:Boolean = false;

        public function ListBase()
        {
            super();
        }

		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value:int):void
		{
			_lastSelectedIndex = _selectedIndex;
			_selectedIndex = value;

			_selectedIndexChangedFlag = true;

			invalidateProperties();
		}

		public function get selectedItem():*
		{
			if(_selectedIndex == -1 || dataProvider == null) return undefined;

			return dataProvider.getItemAt(_selectedIndex);
		}
		
		public function set selectedItem(value:*):void
		{
			var seleIndex:int = dataProvider == null ? -1 : dataProvider.getItemIndex(value);
			selectedIndex = seleIndex;
		}
		
		override public function onCreatedNewItemRender(renderer:DisplayObject):void
		{
			renderer.addEventListener(MouseEvent.ROLL_OVER, itemRenderRollOverHandler, false, 0, true);
			renderer.addEventListener(MouseEvent.ROLL_OUT, itemRenderRollOutHandler, false, 0, true);
			renderer.addEventListener(MouseEvent.MOUSE_DOWN, itemRenderMouseDownHandler, false, 0, true);
			renderer.addEventListener(MouseEvent.CLICK, itemRenderClickHandler, false, 0, true);
			renderer.addEventListener(MouseEvent.DOUBLE_CLICK, itemRenderDoubleClickHandler, false, 0, true);
		}
		
		override public function OnUpdateItemRender(render:DisplayObject, itemIndex:int, itemData:Object):void
		{
			super.OnUpdateItemRender(render, itemIndex, itemData);
			
			if(render is IItemRender)
			{
				IItemRender(render).selected = itemIndex == _selectedIndex;
			}
		}

		override protected function onValidateProperties():void
		{
			super.onValidateProperties();

			if(_selectedIndexChangedFlag)
			{
				_selectedIndexChangedFlag = false;
				
				itemSelected(_lastSelectedIndex, _selectedIndex);
			}
		}

		protected function itemSelected(lastSelectedIndex:int, currentSelectedIndex:int):void
		{
			if(lastSelectedIndex != -1)
			{
				var lastSelectedRenderItem:DisplayObject = DataGroup(myContentGroup).getLayoutChildAt(lastSelectedIndex);
				if(lastSelectedRenderItem != null)
				{
					if(lastSelectedRenderItem is IItemRender)
					{
						IItemRender(lastSelectedRenderItem).selected = false;
					}
				}
			}
			
			if(currentSelectedIndex != -1)
			{
				var currentSelectedRenderItem:DisplayObject = DataGroup(myContentGroup).getLayoutChildAt(currentSelectedIndex);
				if(currentSelectedRenderItem != null)
				{
					if(currentSelectedRenderItem is IItemRender)
					{
						IItemRender(currentSelectedRenderItem).selected = true;
					}
				}
			}
		}
		
		//event handler
		private function itemRenderRollOverHandler(event:MouseEvent):void
		{
			var render:IItemRender = event.currentTarget as IItemRender;
			if(render != null)
			{
				if(hasEventListener(ListEvent.ITEM_RENDER_ROLL_OVER))
				{
					var itmeRenderEvent:ListEvent = new ListEvent(ListEvent.ITEM_RENDER_ROLL_OVER);
					itmeRenderEvent.rowIndex = render.itemIndex;
					itmeRenderEvent.itemRender = render;
					dispatchEvent(itmeRenderEvent);
				}
			}
		}
		
		private function itemRenderRollOutHandler(event:MouseEvent):void
		{
			var render:IItemRender = event.currentTarget as IItemRender;
			if(render != null)
			{
				if(hasEventListener(ListEvent.ITEM_RENDER_ROLL_OUT))
				{
					var itmeRenderEvent:ListEvent = new ListEvent(ListEvent.ITEM_RENDER_ROLL_OUT);
					itmeRenderEvent.rowIndex = render.itemIndex;
					itmeRenderEvent.itemRender = render;
					dispatchEvent(itmeRenderEvent);
				}
			}
		}
		
		private function itemRenderMouseDownHandler(event:MouseEvent):void
		{
			var render:IItemRender = event.currentTarget as IItemRender;
			if(render != null)
			{
				if(hasEventListener(ListEvent.ITEM_RENDER_MOUSE_DOWN))
				{
					var itmeRenderEvent:ListEvent = new ListEvent(ListEvent.ITEM_RENDER_MOUSE_DOWN);
					itmeRenderEvent.rowIndex = render.itemIndex;
					itmeRenderEvent.itemRender = render;
					dispatchEvent(itmeRenderEvent);
				}
			}
		}
		
		private function itemRenderClickHandler(event:MouseEvent):void
		{
			var render:IItemRender = event.currentTarget as IItemRender;
			if(render != null)
			{
				if(hasEventListener(ListEvent.ITEM_RENDER_CLICK))
				{
					var itmeRenderEvent:ListEvent = new ListEvent(ListEvent.ITEM_RENDER_CLICK);
					itmeRenderEvent.rowIndex = render.itemIndex;
					itmeRenderEvent.itemRender = render;
					dispatchEvent(itmeRenderEvent);
				}
			}
		}

		private function itemRenderDoubleClickHandler(event:MouseEvent):void
		{
			var render:IItemRender = event.currentTarget as IItemRender;
			if(render != null)
			{
				if(hasEventListener(ListEvent.ITEM_RENDER_CLICK))
				{
					var itmeRenderEvent:ListEvent = new ListEvent(ListEvent.ITEM_RENDER_DOUBLE_CLICK);
					itmeRenderEvent.rowIndex = render.itemIndex;
					itmeRenderEvent.itemRender = render;
					dispatchEvent(itmeRenderEvent);
				}
			}
		}
    }
}