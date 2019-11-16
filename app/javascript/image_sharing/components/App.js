import React, { Component } from 'react';
import { inject } from 'mobx-react';
import Header from './Header';
import Footer from './Footer';
import FeedbackStore from '../stores/FeedbackStore';
import PostFeedbackService from '../services/PostFeedbackService';
import FeedbackForm from './FeedbackForm';

class App extends Component {
  /* Add Prop Types check*/
  render() {
    const feedbackStore = new FeedbackStore(new PostFeedbackService());
    return (
      <div>
        <Header title="Tell us what you think" />
        <FeedbackForm feedbackStore={feedbackStore} />
        <Footer />
      </div>
    );
  }
}

export default inject('stores')(App);
