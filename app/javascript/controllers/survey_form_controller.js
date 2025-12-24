import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "otherField" ]

  connect() {
    console.log("SurveyFormController connected");
  }

  toggleOther(event) {
    // Find the closest parent div containing the "Other" option and its text field
    const otherContainer = event.target.closest("div.mt-4");
    if (otherContainer) {
      const otherField = otherContainer.querySelector("[data-survey-form-target='otherField']");
      if (otherField) {
        if (event.target.checked) {
          otherField.style.display = "block";
        } else {
          otherField.style.display = "none";
          // Clear the text field when unchecked
          const textInput = otherField.querySelector("input[type='text']");
          if (textInput) {
            textInput.value = "";
          }
        }
      }
    }
  }
}
