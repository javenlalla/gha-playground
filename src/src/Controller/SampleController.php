<?php
declare(strict_types=1);

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class SampleController extends AbstractController
{
    #[Route('/encore/sample', 'encore.sample')]
    public function sampleEncoreSetupPage(): Response
    {
        return $this->render('encore/sample.html.twig');
    }
}
