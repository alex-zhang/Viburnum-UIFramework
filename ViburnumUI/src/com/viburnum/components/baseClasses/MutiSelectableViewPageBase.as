package com.viburnum.components.baseClasses
{
	public class MutiSelectableViewPageBase extends MutiViewPageBase
	{
		private var _selectedIndex:int = -1;
		private var _lastSelectedIndex:int = -1;
		private var _selectedIndexChanged:Boolean = false;
		
		public function MutiSelectableViewPageBase()
		{
			super();
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		[Inspectable(type="Number", defaultValue="0")]
		public function set selectedIndex(value:int):void
		{
			if(_selectedIndex != value)
			{
				_lastSelectedIndex = _selectedIndex;
				_selectedIndex = value;
				
				_selectedIndexChanged = true;
				invalidateProperties();
			}
		}
		
		override public function addViewPageAt(viewPage:ContainerBase, index:int):void
		{
			super.addViewPageAt(viewPage, index);
			
			if(selectedIndex == -1)
			{
				selectedIndex = 0;
			}
		}

		override public function removeViewPageAt(index:int):void
		{
			super.removeViewPageAt(index);
			
			if(selectedIndex == -1)
			{
				if(getViewPageCount() > 0)
				{
					selectedIndex = getViewPageCount() - 1;
				}
			}
		}
		
		override protected function onValidateProperties():void
		{
			super.onValidateProperties();
			
			if(_selectedIndexChanged)
			{
				_selectedIndexChanged = false;

				pageViewSelected(_lastSelectedIndex, _selectedIndex);
			}
		}
		
		protected function pageViewSelected(lastSelectedIndex:int, currentSelectedIndex:int):void
		{
		}
	}
}