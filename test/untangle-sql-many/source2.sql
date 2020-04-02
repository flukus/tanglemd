
create procedure getfoos()
begin

	
	declare @attrId int
	set @attrId = 1

	--select
	select foo
	from bar
	where attrId = @attrId
	--endselect
end
