import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "questionOptions", "allowOther", "valueRange" ]

  connect() {
    console.log("ToggleFieldController connected");
    // Initialize visibility on page load
    this.toggle();
  }

  toggle() {
    const select = this.element.querySelector(".question-type-select");
    if (!select) return;

    const questionType = select.value;
    
    // Show/hide question options and allow_other for single_choice and multiple_choice
    const showOptions = questionType === "single_choice" || questionType === "multiple_choice";
    
    if (this.hasQuestionOptionsTarget) {
      this.questionOptionsTarget.style.display = showOptions ? "block" : "none";
    }
    
    if (this.hasAllowOtherTarget) {
      this.allowOtherTarget.style.display = showOptions ? "flex" : "none";
    }

    // Show/hide value range (min_value, max_value) for rating
    const showValueRange = questionType === "rating";
    
    if (this.hasValueRangeTarget) {
      this.valueRangeTarget.style.display = showValueRange ? "block" : "none";
    }
  }
}
