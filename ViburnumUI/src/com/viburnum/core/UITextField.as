package com.viburnum.core
{
    import com.viburnum.interfaces.IUITextField;
    import com.viburnum.interfaces.IVirburnumDisplayObject;
    
    import flash.text.TextField;
	
    public class UITextField extends TextField implements IUITextField, IVirburnumDisplayObject
    {
        public function UITextField()
        {
            super();
			
			border = true;
        }
		
		override public function set htmlText(value:String):void
		{
			if(value == null) value = "";
			
			super.htmlText = value;
		}
		
		override public function set text(value:String):void
		{
			if(value == null) value = "";
			super.text = value;
		}

		//IVirburnumDisplayObject Interface
        public function move(newX:Number, newY:Number):void
        {
            if(x != newX) this.x = newX;
            if(y != newY) this.y = newY;
        }

        public function setSize(newWidth:Number, newHeight:Number):void
        {
            if(this.width != newWidth) this.width = newWidth;
            if(this.height != newHeight) this.height = newHeight;
        }
    }
}