import { post } from '../utils/helper';

export default class PostFeedbackService {
  postFeedback(body) {
    return post('/api/feedbacks', body);
  }
}
