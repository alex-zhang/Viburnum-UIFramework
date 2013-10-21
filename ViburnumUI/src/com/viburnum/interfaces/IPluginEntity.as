package com.viburnum.interfaces
{
	public interface IPluginEntity
	{
		function addPlugin(pluginName:String, plugin:IPluginComponent):IPluginComponent;
		function removePlugin(pluginName:String):IPluginComponent;
		function hasPluginByName(pluginName:String):Boolean;
		function getPluinByName(pluginName:String):IPluginComponent;
		function getPluinByType(type:Class):IPluginComponent;
	}
}