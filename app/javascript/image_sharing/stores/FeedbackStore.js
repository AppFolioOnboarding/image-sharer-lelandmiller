import { action, computed, observable } from 'mobx';

class FeedbackStore {
  @observable nameObservable = '';
  @observable commentsObservable = '';

  @computed get name() {
    return this.nameObservable;
  }

  @computed get comments() {
    return this.commentsObservable;
  }

  @action setName(name) {
    this.nameObservable = name;
  }

  @action setComments(comments) {
    this.commentsObservable = comments;
  }
}

export default FeedbackStore;
