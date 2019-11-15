import { expect } from 'chai';
import { beforeEach, describe, it } from 'mocha';
import sinon from 'sinon';

import FeedbackStore from '../../stores/FeedbackStore';

describe('FeedbackStore', () => {
  const sandbox = sinon.createSandbox();

  let postFeedbackService;
  let feedbackStore;

  beforeEach(() => {
    postFeedbackService = {
      postFeedback: sandbox.stub().returns(Promise.resolve()),
    };
    feedbackStore = new FeedbackStore(postFeedbackService);
  });

  describe('attributes', () => {
    it('should be able to set and get name', () => {
      feedbackStore.nameObservable = 'frizzle frazzle';

      feedbackStore.setName('bob man');
      expect(feedbackStore.name).equals('bob man');
    });

    it('should be able to set and get comments', () => {
      feedbackStore.commentsObservable = 'old comment';

      feedbackStore.setComments('new comment');
      expect(feedbackStore.comments).equals('new comment');
    });

    it('submitted should start as false', () => {
      expect(feedbackStore.submitted).equals(false);
    });
  });
  describe('actions', () => {
    it('should post feedback and reset values on successful submission', () => {
      expect(feedbackStore.submitted).equals(false);

      feedbackStore.setName('some name');
      feedbackStore.setComments('some comment');

      // FIXME: await might be cleaner, but we need to fix babel config for async support
      return feedbackStore.submit().then(() => {
        expect(feedbackStore.name).equals('');
        expect(feedbackStore.comments).equals('');
        expect(feedbackStore.submitted).equals(true);
        sinon.assert.calledWithExactly(postFeedbackService.postFeedback, {
          name: 'some name',
          comments: 'some comment',
        });
      });
    });

    it('should reset values on reset', () => {
      feedbackStore.nameObservable = 'name';
      feedbackStore.commentsObservable = 'comments';
      feedbackStore.submittedObservable = true;

      feedbackStore.reset();

      feedbackStore.nameObservable = '';
      feedbackStore.commentsObservable = '';
      feedbackStore.submittedObservable = false;
    });
  });
});
