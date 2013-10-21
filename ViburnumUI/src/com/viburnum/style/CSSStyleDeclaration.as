package com.viburnum.style
{
    public final class CSSStyleDeclaration
    {
        private var _styleProtoChain:Object = {};
        
        public function CSSStyleDeclaration(styleProtoChain:Object)
        {
            super();
            
            if(styleProtoChain != null)
            {
                _styleProtoChain = styleProtoChain;
            }
        }
        
        public function getStyleProtoChain():Object
        {
            return _styleProtoChain;
        }
        
        public function getStyle(styleProp:String):*
        {
            return _styleProtoChain[styleProp];
        }
        
        public function setStyle(styleProp:String, newValue:*):void
        {
            if(newValue == undefined || newValue == null)
            {
                delete _styleProtoChain[styleProp];
            }
            else
            {
                _styleProtoChain[styleProp] = newValue;
            }
        }
        
        public function clearStyle(styleProp:String):void
        {
            setStyle(styleProp, undefined);
        }

        //使用c的属性覆盖当前, 一般是子类覆盖父类
        public function overrideStyleProps(c:CSSStyleDeclaration):void
        {
            if(c == null || c.isEmpty()) return;
            
            var protoChain:Object = c.getStyleProtoChain();
            for(var s:String in protoChain)
            {
				_styleProtoChain[s] = protoChain[s]; 
            }
        }
        
        public function isEmpty():Boolean
        {
            for(var s:String in _styleProtoChain)
            {
                return false;
            }
            
            return true;
        }

        public function clone():CSSStyleDeclaration
        {
            var c:CSSStyleDeclaration = new CSSStyleDeclaration(null);
            c.overrideStyleProps(this);
            return c;
        }
    }
}
