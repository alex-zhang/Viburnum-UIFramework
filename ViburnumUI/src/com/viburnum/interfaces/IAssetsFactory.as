package com.viburnum.interfaces
{
	/**
	 * 资源集合工厂接口。
	 * 
	 * 一般用于样式资源和locale资源
	 * @author zhangcheng01
	 * 
	 */	
	public interface IAssetsFactory
	{
		function get assetName():String;
		//Theme/Lang/Module
		function get assetType():String;

		function create(... parameters):Object;
	}
}