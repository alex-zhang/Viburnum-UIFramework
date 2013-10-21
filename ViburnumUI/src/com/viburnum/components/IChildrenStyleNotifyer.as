package com.viburnum.components
{
	public interface IChildrenStyleNotifyer
	{
		//将继承样式的改动广播到child中
		function notifyStyleChangedInChildren(styleProp:String, recursive:Boolean):void;
		function regenerateStyleCache(needUpdateSkinImmediately:Boolean):void;
	}
}