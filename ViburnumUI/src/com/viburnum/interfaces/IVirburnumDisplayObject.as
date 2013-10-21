package com.viburnum.interfaces
{
	public interface IVirburnumDisplayObject extends IDisplayObjectInterface
	{
		function move(newX:Number, newY:Number):void;
		
		function setSize(newWidth:Number, newHeight:Number):void;
	}
}