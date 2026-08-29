{
	AtomicReference<IItemHandler> _iitemhandlerref = new AtomicReference<>();
	if(${input$entity}.hasCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null)) {
		IItemHandler capability = ${input$entity}.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null);
	    _iitemhandlerref.set(capability);
	}
	if (_iitemhandlerref.get() != null) {
		for(int _idx = 0; _idx < _iitemhandlerref.get().getSlots(); _idx++) {
			ItemStack itemstackiterator = _iitemhandlerref.get().getStackInSlot(_idx).copy();
			${statement$foreach}
		}
	}
}