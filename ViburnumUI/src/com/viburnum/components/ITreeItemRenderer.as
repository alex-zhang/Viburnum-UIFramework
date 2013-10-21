package com.viburnum.components
{

	public interface ITreeItemRenderer extends IItemRender
	{
		function get hasBranch():Boolean;
		function set hasBranch(value:Boolean):void;
		
		function get leafIcon():Class;
		function set leafIcon(value:Class):void;
		
		function get folderIcon():Class;
		function set folderIcon(value:Class):void;
		
		function get treeOwner():Tree;
		function set treeOwner(value:Tree):void;
		
		function get isOpen():Boolean;
		function set isOpen(value:Boolean):void;
		
		function get depth():uint;
		function set depth(value:uint):void;
	}
}