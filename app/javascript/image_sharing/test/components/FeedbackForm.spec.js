import React from 'react';
import { shallow } from 'enzyme';
import { expect } from 'chai';
import { afterEach, beforeEach, describe, it } from 'mocha';
import sinon from 'sinon';

import FeedbackForm from '../../components/FeedbackForm';

describe('<FeedbackForm />', () => {
  const sandbox = sinon.createSandbox();

  let props;

  beforeEach(() => {
    props = {
      feedbackStore: {
        name: '',
        comments: '',
        setName: sandbox.stub(),
        setComments: sandbox.stub(),
      },
    };
  });

  afterEach(() => {
    sandbox.restore();
  });

  describe('renders', () => {
    it('shows name', () => {
      props.feedbackStore.name = 'Cool Guy';

      const wrapper = shallow(<FeedbackForm {...props} />);

      const input = wrapper.find('.js-name-input');

      expect(input.prop('value')).equals('Cool Guy');
    });

    it('shows comment', () => {
      props.feedbackStore.comments = 'I am angry!!!';

      const wrapper = shallow(<FeedbackForm {...props} />);

      const input = wrapper.find('.js-comments-input');

      expect(input.prop('value')).equals('I am angry!!!');
    });
  });

  describe('#setName', () => {
    it('sets the name', () => {
      const wrapper = shallow(<FeedbackForm {...props} />);
      wrapper.instance().setName({ target: { value: 'Not Cool Guy' } });

      sinon.assert.calledWithExactly(props.feedbackStore.setName, 'Not Cool Guy');
    });
  });

  describe('#setComments', () => {
    it('sets the comment', () => {
      const wrapper = shallow(<FeedbackForm {...props} />);
      wrapper.instance().setComments({ target: { value: 'Great job guys!' } });

      sinon.assert.calledWithExactly(props.feedbackStore.setComments, 'Great job guys!');
    });
  });
});
