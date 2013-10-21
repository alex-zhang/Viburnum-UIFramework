package com.viburnum.components
{
    import com.viburnum.components.baseClasses.ToggleButtonBase;
    
    import flash.events.MouseEvent;

    public class RadioButton extends ToggleButtonBase
    {
		private var _group:RadioButtonGroup;
		
        public function RadioButton()
        {
            super();
			
			label = "RadioButton";
        }
		
		//dont work
		override public function get autoRepeat():Boolean { return false;}
		override public function set autoRepeat(value:Boolean):void { return;}
		
		public function get group():RadioButtonGroup
		{
			return 	_group;
		}
		
		public function set group(value:RadioButtonGroup):void
		{
			if(_group != null)
			{
				_group.removeRadioButton(this);
			}
			
			_group = value;
			
			if(_group != null)
			{
				_group.addRadioButton(this);
			}
		}
		
		override protected function clickHandler(event:MouseEvent):void
		{
			super.clickHandler(event);

			if(enabled)
			{
				super.selected = true;	
			}
		}
    }
}