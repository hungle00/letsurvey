import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "template", "fieldContainer" ]

  connect() {
    console.log("SurveyFormController connected");
  }

  addQuestion() {
    const template = this.templateTarget.innerHTML;
    const questionIndex = this.getNextQuestionIndex();
    
    // Append template content directly to fieldContainer
    this.fieldContainerTarget.insertAdjacentHTML("beforeend", template);
    
    // Update form field names with unique index to avoid conflicts
    this.updateFormFieldNames(questionIndex);
  }

  removeQuestion(event) {
    event.preventDefault();
    const questionElement = event.target.closest(".question");
    if (questionElement) {
      questionElement.remove();
    }
  }

  getNextQuestionIndex() {
    // Get the number of existing question forms to create unique index
    const existingQuestions = this.fieldContainerTarget.querySelectorAll(".question");
    return existingQuestions.length;
  }

  updateFormFieldNames(index) {
    // Get the last added question form
    const questions = this.fieldContainerTarget.querySelectorAll(".question");
    const lastQuestion = questions[questions.length - 1];
    
    if (!lastQuestion) return;
    
    // Update all form field names to include index
    const form = lastQuestion.querySelector("form");
    if (!form) return;
    
    const inputs = form.querySelectorAll("input, select, textarea");
    inputs.forEach(input => {
      if (input.name) {
        // Replace the name attribute with indexed version
        // Example: question[question_text] -> question[questions_attributes][0][question_text]
        const nameMatch = input.name.match(/question\[(.+)\]/);
        if (nameMatch) {
          input.name = `question[questions_attributes][${index}][${nameMatch[1]}]`;
        }
      }
      
      // Update id if it exists
      if (input.id) {
        const idMatch = input.id.match(/question_(.+)/);
        if (idMatch) {
          input.id = `question_questions_attributes_${index}_${idMatch[1]}`;
        }
      }
    });
    
    // Update labels
    const labels = form.querySelectorAll("label");
    labels.forEach(label => {
      if (label.getAttribute("for")) {
        const forMatch = label.getAttribute("for").match(/question_(.+)/);
        if (forMatch) {
          label.setAttribute("for", `question_questions_attributes_${index}_${forMatch[1]}`);
        }
      }
    });
  }

}
