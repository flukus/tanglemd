
create procedure getfoos()
begin

	--getatt
	declare @attrId int
	select attrId=id
	from Attributes
	where name='blah'
	--getattend

	--select
	select foo
	from bar
	where attrId = @attrId
	--endselect
end
