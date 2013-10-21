package com.viburnum.events
{
	/**
	 *  DataChangeKind 类包含代 类 kind 属性的有效值的常量。
	 * 这些常量指示对集合进行的更改类型。 
	 */
	public final class CollectionEventKind
	{
		/**
		 *  指示集合添加了一个项目。
		 *  item, location
		 */
		public static const ADD:String = "add";
		
		/**
		 *  指示项目已从 CollectionEvent oldLocation 属性确定的位置移动到 location 属性确定的位置。
		 *  
		 */
//		public static const MOVE:String = "move";
		
		/**
		 * 指示集合应用了排序或/和筛选。
		 */
		public static const REFRESH:String = "refresh";
		
		/**
		 *  指示集合删除了一个项目
		 *  oldItem,location
		 */
		public static const REMOVE:String = "remove";
		
		/**
		 * 指示已替换由 CollectionEvent location 属性确定的位置处的项目。
		 * item, oldItem, location
		 */ 
		public static const REPLACE:String = "replace";
		
		/**
		 *  指示集合已彻底更改，需要进行重置。
		 */
		public static const RESET:String = "reset";
		
		/**
		 *  指示集合中一个项目的属性进行了更新
		 * item,location,property,propertyValue,propertyOldValue
		 */
		public static const UPDATE:String = "update";
	}
}
