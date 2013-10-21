package com.viburnum.components
{
    import com.viburnum.events.ViburnumEvent;
    
    import flash.display.Sprite;
    import flash.events.Event;

    public class RadioButtonGroup extends Sprite
    {
//		private var _name:String;
		
		private var _radioButtons:Array = [];
		private var _selection:RadioButton;
		
        public function RadioButtonGroup()
        {
            super();
        }
		
//		public function get name():String
//		{
//			return _name;
//		}
		
		[Inspectable(type="String")]
		override public function set name(value:String):void
		{
			super.name = value;
		}
		
		public function get selection():RadioButton
		{
			return _selection;
		}

		public function set selection(value:RadioButton):void
		{
			if(getRadioButtonIndex(value) == -1 || _selection == value) return;

			if(_selection != null)
			{
				_selection.selected = false;
			}
			
			_selection = value;
			
			if(_selection != null)
			{
				_selection.selected = true;
			}
		}
		
		public function get numRadioButtons():int
		{
			return _radioButtons.length;
		}
		
		public function addRadioButton(radioButton:RadioButton):void 
		{
			if(radioButton == null) return;

			radioButton.addEventListener(ViburnumEvent.VALUE_CHANGED, radioButtonValueChangedHandler);

			_radioButtons.push(radioButton);
		}

		public function removeRadioButton(radioButton:RadioButton):void
		{
			if(radioButton == null) return;
			
			var index:int = getRadioButtonIndex(radioButton);
			if(index != -1)
			{
				radioButton.removeEventListener(ViburnumEvent.VALUE_CHANGED, radioButtonValueChangedHandler);
				_radioButtons.splice(index, 1);
			}
		}
		
		public function getRadioButtonAt(index:int):RadioButton
		{
			return _radioButtons[index];
		}
		
		public function getRadioButtonIndex(radioButton:RadioButton):int
		{
			return _radioButtons.indexOf(radioButton);
		}
		
		private function radioButtonValueChangedHandler(event:ViburnumEvent):void
		{
			var radioButton:RadioButton = event.currentTarget as RadioButton;
			if(radioButton.selected)
			{
				selection = radioButton;
			}
		}
		
		private function radioButtonRemoveFromStageHandler(event:Event):void
		{
			var radioButton:RadioButton = event.currentTarget as RadioButton;
			removeRadioButton(radioButton);
		}
    }
}