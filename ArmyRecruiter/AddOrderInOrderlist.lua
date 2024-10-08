function addOrderInOrderlist(list, newOrder)
    local index = 0;
    for i, order in pairs(list) do
        if order.OccursInPhase ~= nil and order.OccursInPhase > newOrder.OccursInPhase then
            index = i;
            break;
        end
    end
    if index == 0 then index = #list + 1; end
    table.insert(list, index, newOrder);
end