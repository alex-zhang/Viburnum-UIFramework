package com.viburnum.utils
{
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    
    public final class DisplayUtil
    {
        public static function walkDisplayObjects(displayObject:DisplayObject, callbackFunction:Function):void
        {
            callbackFunction(displayObject)

            if (displayObject is DisplayObjectContainer)
            {
                var n:int = DisplayObjectContainer(displayObject).numChildren;
                
                for (var i:int = 0; i < n; i++)
                {
                    var child:DisplayObject = DisplayObjectContainer(displayObject).getChildAt(i);
                    
                    walkDisplayObjects(child, callbackFunction);
                }
            }
        }
    }
}
