import { expect } from 'chai';
import { describe, it } from 'mocha';

import FeedbackStore from '../../stores/FeedbackStore';

describe('FeedbackStore', () => {
  it('should be able to set and get name', () => {
    const feedbackStore = new FeedbackStore();
    feedbackStore.nameObservable = 'frizzle frazzle';

    feedbackStore.setName('bob man');
    expect(feedbackStore.name).equals('bob man');
  });

  it('should be able to set and get comments', () => {
    const feedbackStore = new FeedbackStore();
    feedbackStore.commentsObservable = 'old comment';

    feedbackStore.setComments('new comment');
    expect(feedbackStore.comments).equals('new comment');
  });
});
