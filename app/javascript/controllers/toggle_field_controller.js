import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "questionOptions", "allowOther", "valueRange", "placeholder" ]

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

    // Show/hide placeholder for text/email questions
    const showPlaceholder = questionType === "text" || questionType === "single_choice" || questionType === "multiple_choice";
    console.log(this.placeholderTarget);
    if (this.hasPlaceholderTarget) {
      console.log(showPlaceholder);
      this.placeholderTarget.style.display = showPlaceholder ? "block" : "none";
    }
  }

  applyOption(e) {
    const currentOption = e.target.selectedOptions[0];
    if (!currentOption) return;
    console.log(currentOption.label)
    document.querySelector('#question-text-label').textContent = currentOption.label;
    document.querySelector('#question-text-label').classList.remove('hidden');
  }
}
