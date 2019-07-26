class TriggerMultipleActionsAction {
  final List actions;
  TriggerMultipleActionsAction(this.actions);
}

class ShowDialogueMessageAction {
  final String title;
  final String message;

  ShowDialogueMessageAction(this.title, this.message);
}

class ClearDialogueMessageAction{}
