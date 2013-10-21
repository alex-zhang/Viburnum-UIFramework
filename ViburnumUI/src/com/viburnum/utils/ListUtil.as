package com.viburnum.utils
{
	import com.viburnum.data.IHiberarchyNode;

	public final class ListUtil
	{
		public static function getItemDataByValueByKeyField(itemData:Object, keyField:String, f:Function = null):*
		{
			if(itemData == null || !keyField) return undefined;
			
			if(f != null)
			{
				try
				{
					return f(itemData, keyField);
				}
				catch(error:Error) {};
			}
			
			if(itemData is XML)
			{
				try
				{
					return itemData["@" + keyField];
				}
				catch(error:Error) {};
			}
			else if(itemData is IHiberarchyNode)
			{
				return IHiberarchyNode(itemData).toValueByKeyField(keyField);
			}
			else if(itemData is String || 
				itemData is Number || 
				itemData is int || 
				itemData is uint || itemData is Array || itemData is Vector)
			{
				return (itemData).toString();
			}
			else if(itemData is Object)
			{
				try
				{
					return itemData[keyField];
				}
				catch(error:Error) {};
			}
			
			return undefined;
		}
	}
}