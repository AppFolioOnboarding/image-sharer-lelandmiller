import React from 'react';
import { observer } from 'mobx-react';
import PropTypes from 'prop-types';

@observer
export default class FeedbackForm extends React.Component {
  setName = (event) => {
    const { feedbackStore } = this.props;
    feedbackStore.setName(event.target.value);
  };

  setComments = (event) => {
    const { feedbackStore } = this.props;
    feedbackStore.setComments(event.target.value);
  };

  onSubmit = (event) => {
    // TODO: implement
    event.preventDefault();
  };

  render() {
    const { feedbackStore } = this.props;

    return (
      <form onSubmit={this.onSubmit}>
        <div>
          <label htmlFor='name-input'>
            <span>Your Name:</span>
            <input
              id='name-input'
              className='js-name-input'
              value={feedbackStore.name}
              onChange={this.setName}
            />
          </label>
        </div>
        <div>
          <label htmlFor='comment-textarea'>
            <span>Comments:</span>
            <textarea
              id='comment-textarea'
              className='js-comments-input'
              value={feedbackStore.comments}
              onChange={this.setComments}
            />
          </label>
        </div>
        <div>
          <input type='submit' />
        </div>
      </form>
    );
  }
}

FeedbackForm.propTypes = {
  feedbackStore: PropTypes.object.isRequired,
};
