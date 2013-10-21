package com.viburnum.events
{
    import flash.events.Event;

	/**
	 *  PropertyChangeEvent 类代表对象的一个属性发生更改时传递到事件侦听器的事件对象，并提供有关更改的信息。
	 * 此事件由集合类使用，并且是集合了解其提供的数据发生更改的唯一方式。
	 * Flex 数据绑定机制也使用此事件。
	 */
    public class PropertyChangeEvent extends Event
    {
        public static const PROPERTY_CHANGE:String = "propertyChange";
        
		/**
		 * 指定更改的类型
		 */		
        public var kind:String = null;//PropertyChangeEventKind or null
		
		/**
		 * 更改后的属性的值。
		 */		
        public var newValue:Object = null;
		
		/**
		 * 更改前的属性的值。  
		 */		
        public var oldValue:Object = null;
		
		/**
		 * 指定已更改属性的 String、QName 或 int。 
		 */		
        public var property:Object = null;
		
		/**
		 * 发生更改的对象。  
		 */		
        public var source:Object = null;
        
        public function PropertyChangeEvent(type:String, bubbles:Boolean = false,
                                            cancelable:Boolean = false,
                                            kind:String = null,
                                            property:Object = null, 
                                            oldValue:Object = null,
                                            newValue:Object = null,
                                            source:Object = null)
        {
            super(type, bubbles, cancelable);
            
            this.kind = kind;
            this.property = property;
            this.oldValue = oldValue;
            this.newValue = newValue;
            this.source = source;
        }
        
        override public function clone():Event
        {
            var event:Event = new PropertyChangeEvent(type, bubbles, cancelable, kind,
                property, oldValue, newValue, source);
            return event;
        }
    }
}