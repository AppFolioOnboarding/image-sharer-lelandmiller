import { action, computed, observable } from 'mobx';

class FeedbackStore {
  @observable nameObservable = '';
  @observable commentsObservable = '';
  @observable submittedObservable = false;

  constructor(postFeedbackService) {
    this.postFeedbackService = postFeedbackService;
  }

  @computed get name() {
    return this.nameObservable;
  }

  @computed get comments() {
    return this.commentsObservable;
  }

  @computed get submitted() {
    return this.submittedObservable;
  }

  @action setName(name) {
    this.nameObservable = name;
  }

  @action setComments(comments) {
    this.commentsObservable = comments;
  }

  @action submit() {
    return this.postFeedbackService.postFeedback({
      name: this.nameObservable,
      comments: this.commentsObservable,
    }).then(() => {
      this.nameObservable = '';
      this.commentsObservable = '';
      this.submittedObservable = true;
    }).catch((reason) => {
      // TODO error handling
      throw reason;
    });
  }

  @action reset() {
    this.nameObservable = '';
    this.commentsObservable = '';
    this.submittedObservable = false;
  }
}

export default FeedbackStore;
