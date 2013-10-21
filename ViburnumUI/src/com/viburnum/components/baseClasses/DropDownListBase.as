package com.viburnum.components.baseClasses
{
    import com.viburnum.components.IFocusManagerComponent;
    import com.viburnum.components.IUIComponent;
    import com.viburnum.components.SkinableComponent;
    import com.viburnum.data.IList;
    import com.viburnum.events.DropDownEvent;
    import com.viburnum.events.ViburnumMouseEvent;
    import com.viburnum.layouts.PositionConstrainType;
    
    import flash.display.DisplayObject;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;

	/**
	 *  DropDownListBase 控件包含下拉列表，用户可从中选择单个值。
	 *  其功能与 HTML 中 SELECT 表单元素的功能非常相似。
	 *
	 *  <p>DropDownListBase 控件由锚点按钮和下拉列表构成。
	 * 		使用锚点按钮可打开和关闭下拉列表。 
	 *  </p>
	 *
	 *  <p>打开下拉列表时：</p>
	 *  <ul>
	 *    <li>单击锚点按钮会关闭下拉列表并提交当前选定的数据项目。</li>
	 *    <li>在下拉列表之外单击会关闭下拉列表并提交当前选定的数据项目。</li>
	 *    <li>Clicking on a data item selects that item and closes the drop-down list.</li>
	 *    <li>在某个数据项目上单击会选中该项目并关闭下拉列表。</li>
	 *    <li>如果 requireSelection 属性为 false，则按下 Ctrl 键的同时单击某个数据项目会取消选中该项目并关闭下拉列表。</li>
	 *  </ul>
	 */
    public class DropDownListBase extends SkinableComponent implements IFocusManagerComponent
    {
		protected var dropDownTarget:DisplayObject;
		protected var openButton:ButtonBase;
		
		private var _isDropDownOpen:Boolean = false;
		
		private var _dataProvider:IList;
		private var _dataProviderChangedFlag:Boolean = false;
		
		private var _selectedIndex:int = -1;
		private var _selectedIndexChangedFlag:Boolean = false;
		
        public function DropDownListBase()
        {
            super();
        }
		
		public function get isDropDownOpen():Boolean
		{
			return _isDropDownOpen;
		}
		
		public function get dataProvider():IList
		{
			return _dataProvider;
		}
		
		[Inspectable(type="List")]
		public function set dataProvider(value:IList):void
		{
			if(_dataProvider != value)
			{
				_dataProvider = value; 
				_dataProviderChangedFlag = true;
				
				invalidateProperties();
			}
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		[Inspectable(type="Number")]
		public function set selectedIndex(value:int):void
		{
			if(_selectedIndex != value)
			{
				_selectedIndex = value;
				
				_selectedIndexChangedFlag = true;
				invalidateProperties();
			}
		}
		
		public function openDropDown():void
		{
			if(!_isDropDownOpen)
			{
				_isDropDownOpen = true;

				if(dropDownTarget == null)
				{
					dropDownTarget = createDropDownTarget();
				}
				
				addPopupDropDown(dropDownTarget);
				
				if(hasEventListener(DropDownEvent.OPEN))
				{
					dispatchEvent(new DropDownEvent(DropDownEvent.OPEN));
				}
			}
		}

		public function closeDropDown():void
		{
			if(_isDropDownOpen)
			{
				_isDropDownOpen = false;

				if(dropDownTarget != null)
				{
					removePopupDropDown(dropDownTarget);
				}
				
				if(hasEventListener(DropDownEvent.CLOSE))
				{
					dispatchEvent(new DropDownEvent(DropDownEvent.CLOSE));
				}
			}
		}

		protected function createDropDownTarget():DisplayObject
		{
			return null;
		}

		protected function addPopupDropDown(dropDown:DisplayObject):void
		{
			dropDown.addEventListener(ViburnumMouseEvent.POPUP_CHILD_MOUSE_DOWN_OUTSIDE, popupChildMouseDownOutSideHandler);

			if(dropDown is IUIComponent)
			{
				IUIComponent(dropDown).owner = this;
			}

			if(popupManager != null)
			{
				popupManager.addPopUp(dropDown, false);
				popupManager.constrainPostion(dropDown, PositionConstrainType.CUSTOM_LIMITED);
			}
		}
		
		protected function removePopupDropDown(dropDown:DisplayObject):void
		{
			dropDown.removeEventListener(ViburnumMouseEvent.POPUP_CHILD_MOUSE_DOWN_OUTSIDE, popupChildMouseDownOutSideHandler);
			
			if(popupManager != null)
			{
				popupManager.removePopUp(dropDown);
			}
		}
		
		override protected function onValidateProperties():void
		{
			super.onValidateProperties();
			
			if(_dataProviderChangedFlag)
			{
				_dataProviderChangedFlag = false;
				
				dataProviderChanged();
			}
			
			if(_selectedIndexChangedFlag)
			{
				_selectedIndexChangedFlag = false;
				
				selectedIndexChanged();
			}
		}
		
		protected function dataProviderChanged():void
		{
		}
		
		protected function selectedIndexChanged():void
		{
		}
		
		//event
		private function popupChildMouseDownOutSideHandler(event:ViburnumMouseEvent):void
		{
			closeDropDown();
		}

		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			super.keyDownHandler(event);
			
			if(event.keyCode == Keyboard.SPACE)
			{
				if(isDropDownOpen)
				{
					closeDropDown();
				}
				else
				{
					openDropDown();
				}
			}
		}
		
		override protected function focusOutHandler(event:FocusEvent):void
		{
			super.focusOutHandler(event);
			
			closeDropDown();
		}
		
		override protected function onDetachFromDisplayList():void
		{
			super.onDetachFromDisplayList();
			
			closeDropDown();
		}
    }
}