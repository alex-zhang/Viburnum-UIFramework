package com.viburnum.components
{
    import com.viburnum.components.baseClasses.ToggleButtonBase;

    public class CheckBox extends ToggleButtonBase
    {
        public function CheckBox()
        {
            super();

			label = "CheckBox";
        }
		
		[Inspectable(type="String", defaultValue="CheckBox")]
		override public function set label(value:String):void
		{
			super.label = value;
		}
    }
}