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
        submit: sandbox.spy(),
      },
    };
  });

  afterEach(() => {
    sandbox.restore();
  });

  describe('renders', () => {
    it('shows name before submitted', () => {
      props.feedbackStore.name = 'Cool Guy';

      const wrapper = shallow(<FeedbackForm {...props} />);

      const input = wrapper.find('.js-name-input');

      expect(input.prop('value')).equals('Cool Guy');
    });

    it('shows comment before submitted', () => {
      props.feedbackStore.comments = 'I am angry!!!';

      const wrapper = shallow(<FeedbackForm {...props} />);

      const input = wrapper.find('.js-comments-input');

      expect(input.prop('value')).equals('I am angry!!!');
    });

    it('shows message when submitted', () => {
      props.feedbackStore.submitted = true;

      const wrapper = shallow(<FeedbackForm {...props} />);

      const input = wrapper.find('p');

      expect(input.text()).equals('Thank you for your feedback!');
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

  describe('#setComments', () => {
    it('sets the comment', () => {
      const event = {
        preventDefault: sandbox.spy(),
      };
      const wrapper = shallow(<FeedbackForm {...props} />);

      wrapper.instance().onSubmit(event);

      sinon.assert.calledWithExactly(event.preventDefault);
      sinon.assert.calledWithExactly(props.feedbackStore.submit);
    });
  });
});
