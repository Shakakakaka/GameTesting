extends Resource

class_name Inventory

var stackSize = 20
signal updated
@export var slots: Array[InventorySlot]


func insert(item: InventoryItem):
	for slot in slots:
		if slot.item == item and slot.amount < stackSize:
			slot.amount += 1
			updated.emit()
			return


	for i in range(slots.size()):
		if !slots[i].item:
			slots[i].item = item
			slots[i].amount = 1
			updated.emit()
			return

func removeItemAtIndex(index: int):
	slots[index] = InventorySlot.new()


func insertSlot(index: int, inventorySlot: InventorySlot):
	var oldIndex: int = slots.find(inventorySlot)
	removeItemAtIndex(oldIndex)
	
	slots[index] = inventorySlot
