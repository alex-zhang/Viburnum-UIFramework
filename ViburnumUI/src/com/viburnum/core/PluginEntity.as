package com.viburnum.core
{
	import com.viburnum.interfaces.IPluginComponent;
	import com.viburnum.interfaces.IPluginEntity;

	public class PluginEntity implements IPluginEntity
	{
		public var host:IPluginEntity;
		
		protected var myPlugins:Array = [];//IPluginComponent
		
		public function PluginEntity(host:IPluginEntity)
		{
			super();
			
			this.host = host;
		}
		
		public function addPlugin(pluginName:String, plugin:IPluginComponent):IPluginComponent
		{
			if(plugin && !hasPluginByName(pluginName))
			{
				myPlugins[pluginName] = plugin;
				
				onAddedPlugin(plugin);
				
				return plugin;
			}

			return null;
		}
		
		protected function onAddedPlugin(plugin:IPluginComponent):void
		{
			//there's some error bug appear when i wrote like this, plugin.pluginEntity = host != null ? host : this
			//or like this plugin.pluginEntity = host || this;
			
			if(host != null)
			{
				plugin.pluginEntity = host;
			}
			else
			{
				plugin.pluginEntity = this;
			}
			
			plugin.onAttachToPluginEntity();
		}
		
		public function removePlugin(pluginName:String):IPluginComponent
		{
			var plugin:IPluginComponent = getPluinByName(pluginName);
			
			if(plugin)
			{
				delete myPlugins[pluginName];
				
				onRemovePlugin(plugin);
				
				return plugin;
			}
			
			return null;
		}
		
		protected function onRemovePlugin(plugin:IPluginComponent):void
		{
			plugin.onDettachFromPluginEntity();
			plugin.pluginEntity = null;
		}
		
		public function hasPluginByName(pluginName:String):Boolean
		{
			return Boolean(myPlugins[pluginName]);
		}
		
		public function getPluinByName(pluginName:String):IPluginComponent
		{
			return myPlugins[pluginName];
		}
		
		public function getPluinByType(type:Class):IPluginComponent
		{
			for each(var plugin:IPluginComponent in myPlugins)
			{
				if(plugin is type)
				{
					return plugin;
				}
			}
			
			return null;
		}
	}
}