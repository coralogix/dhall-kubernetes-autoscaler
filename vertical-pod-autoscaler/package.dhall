let imports = ../imports.dhall

let Kubernetes = imports.Kubernetes

let Prelude = imports.Prelude

let ContainerResourcePolicy =
      { Type =
          { containerName : Text
          , mode : Text
          , minAllowed : Optional (Prelude.Map.Type Text Text)
          , maxAllowed : Optional (Prelude.Map.Type Text Text)
          }
      , default =
        { minAllowed = None (Prelude.Map.Type Text Text)
        , maxAllowed = None (Prelude.Map.Type Text Text)
        }
      }

let PodUpdatePolicy =
      { Type = { updateMode : Text }, default.updateMode = "Off" }

let PodResourcePolicy =
      { Type =
          { containerPolicies : Optional (List ContainerResourcePolicy.Type) }
      , default.containerPolicies = None (List ContainerResourcePolicy.Type)
      }

let RecommendedContainerResources =
      { Type =
          { containerName : Text
          , target : Optional (Prelude.Map.Type Text Text)
          , lowerBound : Optional (Prelude.Map.Type Text Text)
          , upperBound : Optional (Prelude.Map.Type Text Text)
          , uncappedTarget : Optional (Prelude.Map.Type Text Text)
          }
      , default =
        { target = None (Prelude.Map.Type Text Text)
        , lowerBound = None (Prelude.Map.Type Text Text)
        , upperBound = None (Prelude.Map.Type Text Text)
        , uncappedTarget = None (Prelude.Map.Type Text Text)
        }
      }

let RecommendedPodResources =
      { Type =
          { containerRecommendation :
              Optional (List RecommendedContainerResources.Type)
          }
      , default.containerRecommendation =
          None (List RecommendedContainerResources.Type)
      }

let VerticalPodAutoscalerCondition =
      { Type =
          { type : Text
          , status : Text
          , lastTransitionTime : Text
          , reason : Text
          , message : Text
          }
      , default = {=}
      }

let VerticalPodAutoscalerSpec =
      { Type =
          { targetRef : Kubernetes.CrossVersionObjectReference.Type
          , updatePolicy : PodUpdatePolicy.Type
          , resourcePolicy : Optional PodResourcePolicy.Type
          }
      , default.resourcePolicy = None PodResourcePolicy.Type
      }

let VerticalPodAutoscalerStatus =
      { Type =
          { recommendation : RecommendedPodResources.Type
          , conditions : Optional (List VerticalPodAutoscalerCondition.Type)
          }
      , default.conditions = None (List VerticalPodAutoscalerCondition.Type)
      }

let VerticalPodAutoscaler =
      { Type =
          { apiVersion : Text
          , kind : Text
          , metadata : Kubernetes.ObjectMeta.Type
          , spec : VerticalPodAutoscalerSpec.Type
          , status : Optional VerticalPodAutoscalerStatus.Type
          }
      , default =
        { apiVersion = "autoscaling.k8s.io/v1beta2"
        , kind = "VerticalPodAutoscaler"
        , status = None VerticalPodAutoscalerStatus.Type
        }
      }

let VerticalPodAutoscalerList =
      { Type =
          { apiVersion : Text
          , kind : Text
          , metadata : Kubernetes.ObjectMeta.Type
          , items : Optional (List VerticalPodAutoscaler.Type)
          }
      , default.items = None (List VerticalPodAutoscaler.Type)
      }

in  { ContainerResourcePolicy = ContainerResourcePolicy
    , PodResourcePolicy = PodResourcePolicy
    , PodUpdatePolicy = PodUpdatePolicy
    , RecommendedContainerResources = RecommendedContainerResources
    , RecommendedPodResources = RecommendedPodResources
    , VerticalPodAutoscaler = VerticalPodAutoscaler
    , VerticalPodAutoscalerCondition = VerticalPodAutoscalerCondition
    , VerticalPodAutoscalerList = VerticalPodAutoscalerList
    , VerticalPodAutoscalerSpec = VerticalPodAutoscalerSpec
    , VerticalPodAutoscalerStatus = VerticalPodAutoscalerStatus
    }
