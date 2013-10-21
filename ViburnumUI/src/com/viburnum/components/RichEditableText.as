package com.viburnum.components
{
    import com.viburnum.components.baseClasses.TextBase;

    public class RichEditableText extends TextBase
    {
        public function RichEditableText()
        {
            super();
        }
		
		[Inspectable(type="Boolean")]
		override public function set selectable(value:Boolean):void
		{
			super.selectable = value;
		}
    }
}