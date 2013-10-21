package com.viburnum.skins
{
	import com.viburnum.data.IHiberarchyNode;

	public interface IHiberarchyRelationWireSkin
	{
		function setDepth(value:Number):void;
		function setBranchSize(width:Number, height:Number):void;
		function setFolderSize(width:Number, height:Number):void;
		function setLeafSize(width:Number, height:Number):void;
		function setItemGap(value:Number):void;
		function hasBranch(value:Boolean):void;
		function setIsOpen(value:Boolean):void;
		function setNode(value:IHiberarchyNode):void;
	}
}