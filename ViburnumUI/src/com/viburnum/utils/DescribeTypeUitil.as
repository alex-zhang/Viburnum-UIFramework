package com.viburnum.utils
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	public final class DescribeTypeUitil
	{
		public static function getTargetDescribeTypeXMlInfo(target:*):XML
		{
			return describeType(target);
		}
		
		public function getClassName(intance:*/*instance Not Class*/):String
		{
			var classType:String = getQualifiedClassName(intance);
			return getClassNameByClassType(classType);
		}
		
		public static function getClassNameByClassType(classType:String):String
		{
			var clsIndex:int = classType.indexOf("::");
			var className:String = (clsIndex == -1) ?
				classType :
				classType.substr(clsIndex + 2);
			return className;
		}
		
//		public static function getTargetDescribeTypeObjectInfo(target:*):Object
//		{
//			var describeTypeXMl:XML = describeType(target);
//			var result:Object = getXMLObject(describeTypeXMl);
//			
//			return result;
//		}
//		
//		public static function getXMLObject(value:XML):Object
//		{
//			var xmlObject:Object = {};
//			if(value == null) return xmlObject;
//			
//			var attributesXMLList:XMLList = value.attributes();
//			for each(var attribute:XML in attributesXMLList)
//			{
//				var attributeKey:String = attribute.name();
//				var attributeValue:* = attribute.valueOf();
//				
//				xmlObject[attributeKey] = attributeValue;
//			}
//			
//			var childrenXMLList:XMLList = value.children();
//			for each(var childrenXML:XML in childrenXMLList)
//			{
//				var childName:String = childrenXML.name();
//				var childXmlObject:Object = getXMLObject(childrenXML);
//
//				var childNamesObjects:Array = xmlObject[childName] as Array;
//				if(childNamesObjects == null)//未添加
//				{
//					childNamesObjects = [];
//				}
//				
//				childNamesObjects.push(childXmlObject);
//				xmlObject[childName] = childNamesObjects;
//			}
//
//			return xmlObject;
//		}
		
		//找出一个类当中声明(类变量)为某个元标签(name)的key的值的列表
		//{AccessorName : Value}
//		public static function getInstanceVariablesMetadataValueByKey(targetInstance:*, targetInstanceXML:XML, metadataName:String, key:String):Object
//		{
//			if(!targetInstance || targetInstance is Class) return null;
//			
//			var result:Object = {};
//			
//			var describeTypeXMl:XML = targetInstanceXML != null ?
//				targetInstanceXML:
//				describeType(targetInstance);
//				
//			var variables:XMLList = describeTypeXMl.variable;
//			for each(var variable:XML in variables)
//			{
//				var variableName:String = variable.@name;
//				var metadatas:XMLList = variable.metadata;
//				for each(var metadata:XML in metadatas)
//				{
//					var metaName:String = metadata.@name;
//					if(metaName == metadataName)
//					{
//						var metadaArgs:XMLList = metadata.arg;
//						for each(var metadaArg:XML in metadaArgs)
//						{
//							if(metadaArg.@key == key)
//							{
//								result[variableName] = metadaArg.@value;
//							}
//						}
//					}
//				}
//			}
//			return result;
//		}
		
		//[Style(name="borderSkin", type="Class")]
		//{borderSkin:{name:borderSkin, type="Class"}, ..}
//		public static function getTargetClassMetadataInfoByMetadataName(target:* /*Instance or Class*/, metadataName:String):Object
//		{
//			if(target == null || metadataName == null) return null;
//			
//			var describeTypeXMl:XML = describeType(target);
//			var metadataXMLList:XMLList = null;
//			if(target is Class)
//			{
//				metadataXMLList = describeTypeXMl.factory.metadata.(@name == "Style")
//			}
//			else
//			{
//				metadataXMLList = describeTypeXMl.metadata.(@name == "Style")
//			}
//			
//			var results:Object = {};
//			for each(var metadataXML:XML in metadataXMLList)
//			{
//				if(metadataXML.@name == metadataName)
//				{
//					var metadataItemName:String = null;
//					var metadataItem:Object = {};
//					
//					var metadaArgs:XMLList = metadataXML.arg;
//					for each(var metadaArg:XML in metadaArgs)
//					{
//						var key:String = metadaArg.@key;
//						var value:String = metadaArg.@value;
//						metadataItem[key] = value;
//						
//						if(key == "name")
//						{
//							metadataItemName = value;
//						}
//					}
//					
//					if(metadataItemName != null)
//					{
//						results[metadataItemName] = metadataItem;
//					}
//				}
//			}
//			
//			return results;
//		}
	}
}