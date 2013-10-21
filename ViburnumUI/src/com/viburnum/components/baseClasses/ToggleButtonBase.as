package com.viburnum.components.baseClasses
{
	import com.viburnum.components.Button;
	import com.viburnum.components.IToggleButton;
	import com.viburnum.events.ViburnumEvent;
	
	import flash.events.MouseEvent;

	[Event(name="valueChanged", type="com.viburnum.events.ViburnumEvent")]
	
	include "../../style/styleMetadata/ExtendedStatedBackgroundStyle.as";
	include "../../style/styleMetadata/ExtendedStatedIconStyle.as";
	
    public class ToggleButtonBase extends Button implements IToggleButton
    {
		public static function getStyleDefinition():Array
		{
			return [
				//ExtendedStatedBackgroundStyle
				{name:"backgroundSkin_selected_upSkin", type:"Class"},
				{name:"backgroundSkin_selected_overSkin", type:"Class"},
				{name:"backgroundSkin_selected_downSkin", type:"Class"},
				{name:"backgroundSkin_selected_disabledSkin", type:"Class"},
				
				//ExtendedStatedIconStyle
				{name:"iconSkin_selected_upSkin", type:"Class"},
				{name:"iconSkin_selected_overSkin", type:"Class"},
				{name:"iconSkin_selected_downSkin", type:"Class"},
				{name:"iconSkin_selected_disabledSkin", type:"Class"},
			]
		}
		
		private var _selected:Boolean = false;
		private var _isToggleEnable:Boolean = false;
		
        public function ToggleButtonBase()
        {
			super();
        }
		
		public function get toggleEnable():Boolean
		{
			return _isToggleEnable;
		}
		
		[Inspectable(type="Boolean")]
		public function set toggleEnable(value:Boolean):void
		{
			_isToggleEnable = value;	
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		[Inspectable(type="Boolean")]
		public function set selected(value:Boolean):void
		{
			if(_selected != value)
			{
				_selected = value;
				
				currentState = getCurrentSkinState();
				
				if(hasEventListener(ViburnumEvent.VALUE_CHANGED))
				{
					dispatchEvent(new ViburnumEvent(ViburnumEvent.VALUE_CHANGED));
				}
			}
		}
		
		override protected function getCurrentSkinState():String//up over down disable
		{
			var buttonState:String = super.getCurrentSkinState();
			
			if(!_selected)
			{
				return buttonState;
			}
			else
			{
				return "selected_" + buttonState;
			}
		}
		
		override protected function clickHandler(event:MouseEvent):void
		{
			super.clickHandler(event);
			
			if(enabled && _isToggleEnable)
			{
				selected = !selected;	
			}
		}
    }
}