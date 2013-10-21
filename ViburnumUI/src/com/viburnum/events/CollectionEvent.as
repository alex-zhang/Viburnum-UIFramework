package com.viburnum.events
{
	import flash.events.Event;
	
	/**
	 *  表示在相关联的集合发生更改时分派的事件
	 */
	public class CollectionEvent extends Event
	{
		public static const COLLECTION_CHANGE:String = "collectionChange";

		public var kind:String = null;
		
		public var item:Object = null;
		public var oldItem:Object = null;
		
		public var location:int = -1;
		public var oldLocation:int = -1;
		
		public var property:Object = null;
		public var propertyValue:Object = null
		public var propertyOldValue:Object = null;
		
		public function CollectionEvent(type:String,
										kind:String = null, 
										item:Object = null,
										oldItem:Object = null,
										location:int = -1,
										oldLocation:int = -1, 
										property:Object = null,
										propertyValue:Object = null,
										propertyOldValue:Object = null)
		{
			super(type, false, cancelable);

			this.kind = kind;
			this.item = item;
			this.oldItem = oldItem;
			this.location = location;
			this.oldLocation = oldLocation;
			this.property = property;
			this.propertyValue = propertyValue;
			this.propertyOldValue = propertyOldValue;
		}
		
		override public function toString():String
		{
			return formatToString("CollectionEvent", "kind", "item",
				"oldItem", "location", "oldLocation", "property",
				"propertyValue", "propertyOldValue");
		}
		
		override public function clone():Event
		{
			return new CollectionEvent(type, kind, 
				item, oldItem, 
				location, oldLocation, 
				property, 
				propertyValue, propertyOldValue);
		}
	}
}
