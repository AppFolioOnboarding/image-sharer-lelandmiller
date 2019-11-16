import sinon from 'sinon';
import { afterEach, describe, it } from 'mocha';
import PostFeedbackService from '../../services/PostFeedbackService';
import * as helper from '../../utils/helper';

describe('PostFeedbackService', () => {
  const sandbox = sinon.createSandbox();

  const postFeedbackService = new PostFeedbackService();

  afterEach(() => {
    sandbox.reset();
  });

  describe('postFeedback', () => {
    it('should result in a fetch call with the correct parameters', () => {
      const postStub = sandbox.stub();
      sandbox.replace(helper, 'post', postStub);

      const expectedBody = { name: 'Good Name', comments: 'Bad Comments ' };

      postFeedbackService.postFeedback(expectedBody);

      sinon.assert.calledWith(postStub, '/api/feedbacks', expectedBody);
    });
  });
});
