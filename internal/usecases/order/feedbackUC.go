package order

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/repositories/order"
)

type FeedbackUsecase interface {
	CreateFeedback(feedback *models.Feedback) error
	UpdateFeedback(feedback *models.Feedback) error
	DeleteFeedback(feedback *models.Feedback) error

	GetFeedbackByID(id uint) (*models.Feedback, error)
	GetAllFeedbacksByProductID(productID uint, page, pageSize int) ([]models.Feedback, error)
}

type feedbackUsecase struct {
	feedbackRepo order.FeedbackRepository
}

func NewFeedbackUsecase(feedbackRepo order.FeedbackRepository) FeedbackUsecase {
	return &feedbackUsecase{feedbackRepo}
}

func (u *feedbackUsecase) CreateFeedback(feedback *models.Feedback) error {
	return u.feedbackRepo.CreateFeedback(feedback)
}

func (u *feedbackUsecase) UpdateFeedback(feedback *models.Feedback) error {
	return u.feedbackRepo.UpdateFeedback(feedback)
}

func (u *feedbackUsecase) DeleteFeedback(feedback *models.Feedback) error {
	return u.feedbackRepo.DeleteFeedback(feedback)
}

func (u *feedbackUsecase) GetFeedbackByID(id uint) (*models.Feedback, error) {
	return u.feedbackRepo.GetFeedbackByID(id)
}

func (u *feedbackUsecase) GetAllFeedbacksByProductID(productID uint, page, pageSize int) ([]models.Feedback, error) {
	return u.feedbackRepo.GetAllFeedbacksByProductID(productID, page, pageSize)
}
