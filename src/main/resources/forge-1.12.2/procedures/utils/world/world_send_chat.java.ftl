private static ITextComponent setComponents(ITextComponent value, Consumer<Style>...styleConsumer) {
    for(Consumer<Style> style : styleConsumer)
        style.accept(value.getStyle());
	return value;
}

private static ITextComponent setComponents(ITextComponent value) {
	return this;
}